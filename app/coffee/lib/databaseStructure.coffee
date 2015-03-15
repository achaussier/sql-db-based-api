'use strict'

###*
# @fileOverview All functions used to generate the database structure
###

mysql = require 'mysql'
sqlUtils = require './sql.js'
Q = require 'q'

###*
# Require classes used to build database structure
###
Table = require './databaseStructure/Table.js'
ComplexField = require './databaseStructure/ComplexField.js'
SimpleField = require './databaseStructure/SimpleField.js'

exports.Table = Table
exports.ComplexField = ComplexField
exports.SimpleField = SimpleField


###*
# Get all table name from database
# @param {Object} api Main api object
# @return {Object} Return database results and fields name
# @throw {Object} ParameterError or DatabaseError
# @todo Once v1 shuted down, whe could delete table_name like
###
getTableNamesFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    sql =  'SELECT
                DISTINCT TABLE_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = ' + mysql.escape(dbName) + '
                AND TABLE_NAME NOT LIKE \'api_%\'
                AND TABLE_NAME NOT LIKE \'my_asp%\'
                AND TABLE_NAME NOT LIKE \'frontend%\';'

    queryData =
        sql: sql
        values: []
    tableNames = []

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
                    for row in dbResults.results
                        tableNames.push row.TABLE_NAME
                    defer.resolve tableNames
                ,(error) ->
                    defer.reject error
            )

        ,(error) ->
            defer.reject error
    )
    defer.promise

exports.getTableNamesFromDB = getTableNamesFromDB

###*
# Get all foreign keys from database
# @param {Object} api Main api object
# @return {Object} Return database results and fields name
# @throw {Object} ParameterError or DatabaseError
###
getForeignKeysFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    sql =  'SELECT
                TABLE_NAME,
                COLUMN_NAME,
                REFERENCED_TABLE_NAME,
                REFERENCED_COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.KEY_COLUMN_USAGE
            WHERE
                REFERENCED_TABLE_NAME IS NOT NULL
                AND TABLE_SCHEMA = ' + mysql.escape(dbName) + ';'

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

exports.getForeignKeysFromDB = getForeignKeysFromDB

###*
# Get all views from database
# @param {Object} api Main api object
# @return {Object} Return database results and fields name
# @throw {Object} ParameterError or DatabaseError
###
getViewsFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    sql =  'SELECT
                TABLE_NAME
            FROM
                INFORMATION_SCHEMA.TABLES
            WHERE
                TABLE_SCHEMA = ' + mysql.escape(dbName) + '
                AND TABLE_TYPE = \'VIEW\';'

    queryData =
        sql: sql
        values: []

    tableNames = []

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
                    for row in dbResults.results
                        tableNames.push row.TABLE_NAME
                    defer.resolve tableNames
                ,(error) ->
                    defer.reject error
            )

        ,(error) ->
            defer.reject error
    )
    defer.promise

exports.getViewsFromDB = getViewsFromDB

###*
# Get structure from database
# @param {Object} api Main api object
# @return {Object} Return database results and fields name
# @throw {Object} ParameterError or DatabaseError
###
getStructureFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    sql =  'SELECT
                TABLE_SCHEMA,
                TABLE_NAME,
                COLUMN_NAME,
                ORDINAL_POSITION,
                COLUMN_DEFAULT,
                IS_NULLABLE,
                DATA_TYPE,
                CHARACTER_MAXIMUM_LENGTH,
                CHARACTER_OCTET_LENGTH,
                NUMERIC_PRECISION,
                NUMERIC_SCALE,
                DATETIME_PRECISION,
                CHARACTER_SET_NAME,
                COLLATION_NAME,
                COLUMN_TYPE,
                COLUMN_KEY,
                EXTRA
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = ' + mysql.escape(dbName) + '
                AND TABLE_NAME NOT LIKE \'api_%\'
                AND TABLE_NAME NOT LIKE \'my_asp%\'
                AND TABLE_NAME NOT LIKE \'frontend%\';'

    queryData =
        sql: sql
        values: []

    tableNames = []

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
# Get indexes from database
# @param {Object} api Main api object
# @return {Object} Return database results and fields name
# @throw {Object} ParameterError or DatabaseError
###
getIndexesFromDB = (api) ->
    defer = Q.defer()

    dbName = api.config.database.database
    dbNameLength = dbName.length + 2
    sql =  'SELECT
                DISTINCT SUBSTRING(
                    INNODB_SYS_TABLES.NAME FROM ' + dbNameLength + '
                ) AS table_name,
                INNODB_SYS_INDEXES.NAME AS index_name,
                KEY_COLUMN_USAGE.COLUMN_NAME AS column_name
            FROM
                INFORMATION_SCHEMA.INNODB_SYS_INDEXES
            INNER JOIN INFORMATION_SCHEMA.INNODB_SYS_TABLES
                ON INNODB_SYS_INDEXES.TABLE_ID = INNODB_SYS_TABLES.TABLE_ID
            INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                ON INNODB_SYS_INDEXES.NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
            WHERE
                INNODB_SYS_INDEXES.TYPE = 2
                AND INNODB_SYS_TABLES.NAME LIKE \'' + dbName + '/%\';'

    queryData =
        sql: sql
        values: []

    tableNames = []

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

exports.getIndexesFromDB = getIndexesFromDB

###*
# Get database informations
# @param {Object} api Main API object
# @return {Array} Results for all queries
# @throw {Object} ParameterError or DatabaseError
###
getInformationsFromDB = (api) ->

    ###*
    # Array to store promise to execute with Q.all()
    # @type {Array}
    ###
    promises = []

    promises.push getTableNamesFromDB(api)
    promises.push getForeignKeysFromDB(api)
    promises.push getViewsFromDB(api)
    promises.push getStructureFromDB(api)
    promises.push getIndexesFromDB(api)

    Q.all promises

exports.getInformationsFromDB = getInformationsFromDB
