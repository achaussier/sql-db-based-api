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
