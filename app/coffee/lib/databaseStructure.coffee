'use strict'

###*
# @fileOverview All functions used to generate the database structure
###

globalUtils = require './global.js'
mysql       = require 'mysql'
Q           = require 'q'
apiErrors   = require './errors.js'


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
    ###*
    # Check the Wrapper exists
    ###
    if not api?.database?
        return Q.fcall ->
            throw new apiErrors.ParameterError(
                'api',
                'object',
                api,
                'no-database-wrapper'
            )

    connection  = null
    query       = null

    ###*
    # Get the query to execute, the connection and execute query
    ###
    api.database.getStructureQuery()
        .then (queryData) ->
            query = queryData
            return
        .then(
            api.database.getReadConnection()
                .then (connection) ->
                    api.database.executeSelect connection, query
                    .then (dbResults) ->
                        connection.release()
                        defer.resolve dbResults.results
                .catch (error) ->
                    defer.reject error
        )
        .catch (error) ->
            defer.reject error

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
            throw new apiErrors.ServerError(
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
            originColumn:   part.columnName,
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
