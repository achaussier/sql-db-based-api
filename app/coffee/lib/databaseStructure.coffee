'use strict'

###*
# @fileOverview All functions used to generate the database structure
###

globalUtils = require './global.js'
mysql = require 'mysql'
rmErrors = require './errors.js'
sqlUtils = require './sql.js'
Q = require 'q'

###*
# Require classes used to build database structure and export these classes
###
ComplexField = require './databaseStructure/ComplexField.js'
SimpleField = require './databaseStructure/SimpleField.js'
Relation = require './databaseStructure/Relation.js'
Table = require './databaseStructure/Table.js'
TableRelation = require './databaseStructure/TableRelation.js'
Field = require './databaseStructure/Field.js'

exports.ComplexField = ComplexField
exports.SimpleField = SimpleField
exports.Relation = Relation
exports.Table = Table
exports.TableRelation = TableRelation
exports.Field = Field


###*
# Get structure from database
# @param {Object} api Main api object
# @return {Object} Return all informations used to buid
# @throw {Object} ParameterError or DatabaseError
###
getStructureFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    dbNameLength = dbName.length + 2
    sql = 'SELECT DISTINCT
                LOWER(ISC.TABLE_SCHEMA)             AS tableSchema,
                LOWER(ISC.TABLE_NAME)               AS tableName,
                LOWER(ISC.COLUMN_NAME)              AS columnName,
                ISC.ORDINAL_POSITION                AS ordinalPosition,
                ISC.COLUMN_DEFAULT                  AS defaultValue,
                ISC.IS_NULLABLE                     AS isNullable,
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
# Validate a part of structure returned by database
# @param {Object} structurePart Structure part to test
# @return {Object} Structure part if valid
# @throw {Object} ParameterError if structure part is invalid
###
validateForeignKey = (fk) ->

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

    globalUtils.checkKeysHaveNotNullValues(fk, validKeys)

###*
# Process database structure returned by database
# @param {Array} databaseStructureParts Array with all database structure parts
# @return {Object} A Tables object which contains all created Tables objects
###
processDatabaseStructureParts = (tableNames) ->
    DatabaseStructure = new DatabaseStructure()

    for tableName in tableNames
        tableObjects.push new Table(tableName)

    Q.fcall ->
        tableObjects

exports.processDatabaseStructureParts = processDatabaseStructureParts

###*
# Build Table objects
# @param {Array} tableNames Array with all table names
# @return {Array} An array with a table object for each table name received
###
buildTableObjects = (tableNames) ->
    tableObjects = []

    for tableName in tableNames
        tableObjects.push new Table(tableName)

    Q.fcall ->
        tableObjects

exports.buildTableObjects = buildTableObjects

###*
# Validate a foreign key structure
# @param {Object} fk Foreign key to test
# @return {Object} foreign key if valid
# @throw {Object} ParameterError if foreign key is not valid
###
validateForeignKey = (fk) ->

    validKeys = [
        'originTable'
        'originColumn'
        'destTable'
        'destColumn'
    ]

    globalUtils.checkKeysHaveNotNullValues(fk, validKeys)

###*
# Build relations for a foreign key result
# @param {Object} fk A foreign key returned by database
# @return {Object} Return an object with relation and inverse relation
###
buildRelations = (fk) ->

    validateForeignKey fk
        .then(
            (result) ->
                ###*
                # Build relation for origin table
                ###
                relation = new Relation(
                    fk.originColumn,
                    fk.destTable,
                    fk.destColumn
                )

                ###*
                # Build relation for dest table
                ###
                inverseRelation = new Relation(
                    fk.destColumn,
                    fk.originTable,
                    fk.originColumn
                )

                ###*
                # Return relations
                # @type {Object}
                ####
                relations =
                    relation: relation
                    inverseRelation: inverseRelation

                Q.fcall ->
                    relations

            ,(error) ->
                Q.fcall ->
                    throw error
        )

exports.buildRelations = buildRelations

###*
# Build table relations
# @param {Array} foreignKeys Array with all foreign keys for database
# @return {Object} An object with all relations
# @throw {Object} ParameterError if bad foreign key
###
buildTableRelations = (foreignKeys) ->

    defer = Q.defer()
    tableRels = {}
    promises = []

    for fk in foreignKeys
        do (fk) ->
            promises.push(
                buildRelations fk
                    .then(
                        (relations) ->
                            rel = relations.relation
                            invRel = relations.inverseRelation

                            ###*
                            # If it's the first relation for origin table,
                            # create a TableRelation Object
                            ###
                            if not tableRels[fk.originTable]?
                                tableRel = new TableRelation(fk.originTable)
                                tableRels[fk.originTable] = tableRel

                            tableRels[fk.originTable].addRelation rel

                            ###*
                            # If it's the first relation for dest table, create
                            # a TableRelation Object
                            ###
                            if not tableRels[fk.destTable]?
                                tableRel = new TableRelation(fk.destTable)
                                tableRels[fk.destTable] = tableRel

                            tableRels[fk.destTable].addInverseRelation invRel
                            Q.fcall ->

                        ,(error) ->
                            defer.reject error
                    )
            )
    Q.all promises
        .then(
            (results) ->
                defer.resolve tableRels
            ,(error) ->
                defer.reject error
        )

    defer.promise

exports.buildTableRelations = buildTableRelations

###*
# Validate a field structure
# @param {Object} field Field to test
# @return {Object} Field if valid
# @throw {Object} ParameterError if foreign key is not valid
###
validateField = (field) ->

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
    ]

    sameArrays = globalUtils.areSameArrays validKeys, Object.keys(field)
    if sameArrays and field.tableName? and field.columnName?
        Q.fcall ->
            field
    else
        Q.fcall ->
            throw new rmErrors.ParameterError(
                'field-keys',
                validKeys,
                Object.keys field
            )

exports.validateField = validateField

###*
# Build fields with database result
# @param {Array} dbFields Fields returned by database
# @return {Array} Return an array of Field objects
###
buildFields = (dbFields) ->

    defer = Q.defer()
    fields = []
    promises = []

    for field in dbFields
        do (field) ->
            promises.push(
                validateField field
                    .then(
                        (field) ->
                            fieldObj = new Field(field)
                            fields.push field
                            Q.fcall ->

                        ,(error) ->
                            defer.reject error
                    )
            )
    Q.all promises
        .then(
            (results) ->
                defer.resolve fields
            ,(error) ->
                defer.reject error
        )

    defer.promise

exports.buildFields = buildFields

###*
# Validate an index part
# @param {Object} indexPart Index part to test
# @return {Object} Index part if valid
# @throw {Object} ParameterError if index part is not valid
###
validateIndexPart = (fk) ->

    validKeys = [
        'tableName:'
        'indexName:'
        'columnName:'
    ]

    globalUtils.checkKeysHaveNotNullValues(fk, validKeys)

###*
# Build unique indexes with database result
# @param {Array} dbIndexParts Index parts returned by database
# @return {Array} Return an array of UniqueIndex objects
###
buildUniqueIndexes = (dbIndexParts) ->

    defer = Q.defer()
    uniqueIndexes = []
    promises = []

    for indexPart in dbIndexParts
        do (indexPart) ->
            promises.push(
                validateField indexPart
                    .then(
                        (indexPart) ->
                            indexObj = new UniqueIndex(indexPart)
                            indexes.push indexObj
                            Q.fcall ->

                        ,(error) ->
                            defer.reject error
                    )
            )
    Q.all promises
        .then(
            (results) ->
                defer.resolve indexes
            ,(error) ->
                defer.reject error
        )

    defer.promise

exports.buildUniqueIndexes = buildUniqueIndexes
