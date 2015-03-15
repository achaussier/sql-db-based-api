'use strict'

###*
# @fileOverview High level functions to work with the database
###

Q = require 'q'
rmErrors = require './errors.js'

###*
# Return a promise connection from a read only pool
# @param {Object} api Main api object
# @return {Function} A connection from a read only pool
# @throw {Object} A ParameterError Object if no read only pool
###
getReadOnlyConnection = (api) ->

    defer = Q.defer()
    ###*
    # Check if a read pool exists
    ###
    if not api?.database?.mysql?.readPool?
        errorObj = new rmErrors.ParameterError(
            'api',
            'api-with-mysql-read-pool',
            api,
            'no-mysql-read-pool'
        )
        defer.reject errorObj

    else
        ###*
        # Return a promised version of pool.getConnection method
        ###
        api.database.mysql.readPool.getConnection (error, roConnection) ->
            if error
                errorObj = new rmErrors.DatabaseError(
                    error,
                    'connection-error'
                )
                defer.reject errorObj
            else
                defer.resolve roConnection

    defer.promise

exports.getReadOnlyConnection = getReadOnlyConnection

###*
# Return a promise connection from a write pool
# @param {Object} api Main api object
# @return {Function} A connection from a write pool
# @throw {Object} A ParameterError Object if no write pool
###
getWriteConnection = (api) ->

    defer = Q.defer()

    ###*
    # Check if a write pool exists
    ###
    if not api?.database?.mysql?.writePool?
        errorObj = new rmErrors.ParameterError(
            'api',
            'api-with-mysql-write-pool',
            api,
            'no-mysql-write-pool'
        )
        defer.reject errorObj

    else
        ###*
        # Return a promised version of pool.getConnection method
        ###
        api.database.mysql.writePool.getConnection (error, writeConnection) ->
            if error
                errorObj = new rmErrors.DatabaseError(
                    error,
                    'connection-error'
                )
                defer.reject errorObj
            else
                defer.resolve writeConnection

    defer.promise

exports.getWriteConnection = getWriteConnection

###*
# Validate params of executeSelect function
# @param {Object} connection Database connection
# @param {Object} queryData Query data (sql, option, values)
# @return {Boolean} true if params are valid
# @throw {Object} DatabaseError If parameter are not valid
###
validateExecuteSelect = (connection, queryData) ->

    if not connection?.query?
        errorObj = new rmErrors.ParameterError(
            'connection',
            'Object',
            connection
        )
        errorObj

    else if not queryData?.sql? or queryData.sql is '' or not queryData?.values?
        ###*
        # Check keys of queryData param and check the sql query isn't empty
        ###
        errorObj = new rmErrors.ParameterError(
            'queryData',
            'Object',
            queryData
        )
        errorObj

    else
        true

exports.validateExecuteSelect = validateExecuteSelect

###*
# Execute select sql query
# @param {Object} connection Database connection
# @param {Object} queryData Query data (sql, option, values)
# @return {Object} dbResult Database result fo this query and fields
# @throw {Object} DatabaseError If error occurs during query
###
executeSelect = (connection, queryData) ->

    defer = Q.defer()

    ###*
    # Verify if params are valid
    ###
    validateParams = validateExecuteSelect(
        connection,
        queryData
    )

    if validateParams instanceof rmErrors.ParameterError
        defer.reject validateParams

    else
        ###*
        # If params are valid, execute query
        ###
        connection.query queryData, (error, results, fields) ->
            if error
                errorObj = new rmErrors.DatabaseError(
                    {
                        query: queryData,
                        error : error
                    },
                    'error-during-query-execution'
                )
                defer.reject errorObj

            else
                defer.resolve(
                    results: results
                    fields: fields
                )

    defer.promise

exports.executeSelect = executeSelect
