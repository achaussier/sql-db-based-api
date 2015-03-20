'use strict'

###*
# @fileOverview All functions used to generate the database structure
###

globalUtils = require './global.js'
mysql       = require 'mysql'
Q           = require 'q'
rmErrors    = require './errors.js'
sqlUtils    = require './sql.js'


###*
# Require classes used to build database structure
###
DatabaseStructure   = require './class/DatabaseStructure.js'
Field               = require './class/Field.js'
Relation            = require './class/Relation.js'
Table               = require './class/Table.js'
TableRelation       = require './class/TableRelation.js'


###*
# Get structure from database
# @param {Object} api Main api object
# @return {Object} Return all informations used to buid
# @throw {Object} ParameterError or DatabaseError
###
getStructureFromDB = (api) ->
    defer = Q.defer()

    dbName          = api.config.database.database
    dbNameLength    = dbName.length + 2

    sql = 'SELECT DISTINCT
                LOWER(ISC.TABLE_SCHEMA)             AS tableSchema,
                LOWER(ISC.TABLE_NAME)               AS tableName,
                LOWER(ISC.COLUMN_NAME)              AS columnName,
                ISC.ORDINAL_POSITION                AS ordinalPosition,
                ISC.COLUMN_DEFAULT                  AS defaultValue,
                LOWER(ISC.IS_NULLABLE)              AS isNullable,
                LOWER(ISC.DATA_TYPE)                AS dataType,
                ISC.CHARACTER_MAXIMUM_LENGTH        AS charMaxLength,
                ISC.CHARACTER_OCTET_LENGTH          AS charOctetLength,
                ISC.NUMERIC_PRECISION               AS numPrecision,
                ISC.NUMERIC_SCALE                   AS numScale,
                ISC.DATETIME_PRECISION              AS datetimePrecision,
                ISC.CHARACTER_SET_NAME              AS charSetName,
                ISC.COLLATION_NAME                  AS collationName,
                LOWER(ISC.COLUMN_TYPE)              AS columnType,
                LOWER(ISC.COLUMN_KEY)               AS columnKey,
                LOWER(ISC.EXTRA)                    AS extra,
                LOWER(ISKCU.REFERENCED_TABLE_NAME)  AS refTableName,
                LOWER(ISKCU.REFERENCED_COLUMN_NAME) AS refColumnName,
                LOWER(IST.TABLE_TYPE)               AS tableType,
                LOWER(ISISI.indexName)              AS uniqueIndexName
            FROM
                INFORMATION_SCHEMA.COLUMNS              AS ISC
                INNER JOIN INFORMATION_SCHEMA.TABLES    AS IST
                    ON (
                                ISC.TABLE_NAME      = IST.TABLE_NAME
                            AND ISC.TABLE_SCHEMA    = IST.TABLE_SCHEMA
                        )
                LEFT OUTER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS ISKCU
                    ON (
                                ISC.TABLE_NAME      = ISKCU.TABLE_NAME
                            AND ISC.COLUMN_NAME     = ISKCU.COLUMN_NAME
                            AND ISC.TABLE_SCHEMA    = ISKCU.TABLE_SCHEMA
                            AND ISKCU.REFERENCED_TABLE_NAME IS NOT NULL
                        )
                LEFT OUTER JOIN
                (
                    SELECT
                        DISTINCT SUBSTRING(
                            INNODB_SYS_TABLES.NAME FROM ' + dbNameLength + '
                        )                            AS tableName,
                        ISI.NAME                     AS indexName,
                        KEY_COLUMN_USAGE.COLUMN_NAME AS columnName
                    FROM
                        INFORMATION_SCHEMA.INNODB_SYS_INDEXES AS ISI
                    INNER JOIN INFORMATION_SCHEMA.INNODB_SYS_TABLES
                        ON ISI.TABLE_ID = INNODB_SYS_TABLES.TABLE_ID
                    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                        ON ISI.NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                    WHERE
                        ISI.TYPE = 2
                        AND INNODB_SYS_TABLES.NAME LIKE \'' + dbName + '%\'
                ) AS ISISI
                    ON (
                                ISC.TABLE_NAME  = ISISI.tableName
                            AND ISC.COLUMN_NAME = ISISI.columnName
                        )
            WHERE
                ISC.TABLE_SCHEMA = \'' + dbName + '\'
                AND ISC.TABLE_NAME NOT LIKE \'api_%\'
                AND ISC.TABLE_NAME NOT LIKE \'my_asp%\'
                AND ISC.TABLE_NAME NOT LIKE \'frontend%\';'

    queryData =
        sql: sql
        values: []

    ###*
    # Get an available connection from pool
    ###
    sqlUtils.getReadOnlyConnection api
    .then(
        (connection) ->

            ###*
            # Execute query
            ###
            sqlUtils.executeSelect connection, queryData
            .then(
                (dbResults) ->
                    connection.release()
                    defer.resolve dbResults.results
                ,(error) ->
                    defer.reject error
            )

        ,(error) ->
            defer.reject error
    )
    defer.promise

exports.getStructureFromDB = getStructureFromDB

###*
# Check mandatory values for a part of structure returned by database
# @param {Object} structurePart Structure part to test
# @return {Object} Structure part if valid
# @throw {Object} ParameterError if structure part is invalid
###
checkPartMandatoryValues = (part) ->

    validKeys = [
        'tableSchema'
        'tableName'
        'columnName'
        'isNullable'
        'dataType'
        'columnType'
        'columnKey'
        'extra'
        'tableType'
    ]

    globalUtils.checkKeysHaveNotNullValues(part, validKeys)

exports.checkPartMandatoryValues = checkPartMandatoryValues

###*
# Check keys for a part of structure returned by database
# @param {Object} structurePart Structure part to test
# @return {Object} Structure part if valid
# @throw {Object} ParameterError if structure part is invalid
###
checkPartKeys = (part) ->

    validKeys = [
        'tableSchema'
        'tableName'
        'columnName'
        'ordinalPosition'
        'defaultValue'
        'isNullable'
        'dataType'
        'charMaxLength'
        'charOctetLength'
        'numPrecision'
        'numScale'
        'datetimePrecision'
        'charSetName'
        'collationName'
        'columnType'
        'columnKey'
        'extra'
        'refTableName'
        'refColumnName'
        'tableType'
        'uniqueIndexName'
    ]

    globalUtils.checkKeys(part, validKeys)

exports.checkPartKeys = checkPartKeys

###*
# Create Table if not exists and add it to DatabaseStructure
# @param {Object} dbStructure Structure object
# @param {Object} part Part of database structure returned by database
# @return {Object} Table currently processing
###
setTable = (dbStructure, part) ->

    ###*
    # If table not exists in DatabaseStruture, add it
    ###
    if not dbStructure.containsTable(part.tableName)
        dbStructure.addTable(
            new Table(
                name: part.tableName
                isView: part.tableType.toLowerCase() is 'view'
            )
        )

    ###*
    # Get table Object
    ###
    table = dbStructure.getTable(part.tableName)

    if table
        Q.fcall ->
            ###*
            # Table object should have been created during a relation build.
            # So fix the good isView value beacause it's not know during an
            # inverse relation creation
            ###
            table.isView = part.tableType.toLowerCase() is 'view'
            table
    else
        Q.fcall ->
            throw new rmErrors.ServerError(
                part.tableName,
                'table-not-found-in-database-structure'
            )

exports.setTable = setTable

###*
# Create field object and add it to table object
# @param {Object} table Table object for this part
# @param {Object} part Part of database structure returned by database
# @return {Object} Table currently processing
###
setField = (table, part) ->

    field = new Field(part)
    table.addField(field)

    Q.fcall ->
        table

exports.setField = setField

###*
# Create or update unique index for this part if exists
# @param {Object} table Table object for this part
# @param {Object} part Part of database structure returned by database
# @return {Object} Table currently processing
###
setUniqueIndex = (table, part) ->

    if part.uniqueIndexName?

        ###*
        # Object used to create unique index for part
        ###
        uniqueIndexPart =
            indexName   : part.uniqueIndexName
            tableName   : part.tableName
            columnName  : part.columnName

        table.addUniqueIndexPart uniqueIndexPart

    Q.fcall ->
        table

exports.setUniqueIndex = setUniqueIndex

###*
# Add unique index for this part if exists
# @param {Object} dbStructure Structure object
# @param {Object} table Table object for this part
# @param {Object} part Part of database structure returned by database
# @return {Object} Table currently processing
###
setRelations = (dbStructure, table, part) ->

    if part.refTableName?
        ###*
        # Build relation for origin table
        ###
        relation = new Relation(
            originColumn:   part.tableName,
            destTable:      part.refTableName,
            destColumn:     part.refColumnName
            isInverse:      false
        )

        ###*
        # Build relation for dest table
        ###
        inverseRelation = new Relation(
            originColumn:   part.refColumnName,
            destTable:      part.tableName,
            destColumn:     part.columnName
            isInverse:      true
        )

        ###*
        # If inverse table not exists in DatabaseStruture, add it
        ###
        if not dbStructure.containsTable part.refTableName
            dbStructure.addTable(
                new Table(
                    name: part.refTableName
                    isView: null
                )
            )
        inverseTable = dbStructure.getTable part.refTableName

        ###*
        # Add relations to tables
        ###
        table.addRelation(relation)
        inverseTable.addRelation(inverseRelation)

    Q.fcall ->
        table

exports.setRelations = setRelations

###*
# Process database structure returned by database
# @param {Array} databaseStructureParts Array with all database structure parts
# @return {Object} A Tables object which contains all created Tables objects
###
processDatabaseStructureParts = (dbStructureParts) ->
    dbStructure = new DatabaseStructure()
    promises = []

    ###*
    # Iterate over each database rows
    ###
    for part in dbStructureParts
        do (part) ->

            ###*
            # Check row structure
            ###
            promises.push(
                checkPartMandatoryValues part
                .then checkPartKeys
                .then(
                    (part) ->
                        ###*
                        # Create table if not exists, set isView and return
                        # table
                        ###
                        setTable dbStructure, part
                )
                .then(
                    (table) ->
                        ###*
                        # Create field Object and add it to table
                        ###
                        setField table, part
                )
                .then(
                    (table) ->
                        ###*
                        # Set index informations
                        ###
                        setUniqueIndex table, part
                )
                .then(
                    (table) ->
                        ###*
                        # Manage relations
                        # @todo Add a isMultiple fields to know if subobject is
                        # unique or an array
                        ###
                        setRelations dbStructure, table, part
                )
                .catch (error) ->
                    throw error
            )

    Q.all promises
        .then(
            (results) ->
                Q.fcall ->
                    dbStructure
            ,(error) ->
                Q.fcall ->
                    throw error
        )

exports.processDatabaseStructureParts = processDatabaseStructureParts
