'use strict'

###*
# @fileOverview Intializer used to connect to MariaDB server with mysql driver
###

###*
# Required modules
###
DatabaseWrapper = require '../../lib/class/DatabaseWrapper.js'
Maria10Database = require '../../lib/class/Maria10Database.js'
mysql           = require 'mysql'
rmErrors        = require '../../lib/errors.js'

module.exports =
    loadPriority    : 1000
    startPriority   : 100
    stopPriority    : 1000

    initialize: (api, next) ->

        ###*
        # Create namespace to manage databases
        ###
        if not api.database?
            api.database = null

        next()

    start: (api, next) ->

        dialect = api?.config?.database?.dialect

        ###*
        # Only process this initializer for maria or mysql databases
        ###
        if not dialect?
            return next()
        else if not /^mysql.*$/.test(dialect) and not /^maria.*$/.test(dialect)
            return next()

        ###*
        # Check if this database dialect is managed by this initializer
        ###
        dbObj = switch dialect
            when 'maria10' then new Maria10Database()
            else null

        if not dbObj?
            errorObj = new rmErrors.ServerError(
                dialect,
                'database-dialect-not-implemented'
            )
            return next errorObj

        ###*
        # Create pools and wrap methods
        ###
        dbObj
            .generatePools(api.config.database)
            .then(
                (result) ->
                    wrapper                     = new DatabaseWrapper()
                    wrapper.getReadConnection   = dbObj.getReadConnection
                    wrapper.getWriteConnection  = dbObj.getWriteConnection
                    wrapper.executeSelect       = dbObj.executeSelect
                    wrapper.end                 = dbObj.poolCluster.end
                    api.database                = wrapper
                    next()
                ,(error) ->
                    throw error
            )
            .catch (error) ->
                errorObj = new rmErrors.ServerError(
                    error,
                    'database-connection-error'
                )
                next(errorObj)

    stop: (api, next) ->
        ###*
        # If api is stopping, disconnect from servers if connection exists
        ###
        if api.database?.end?
            api.database.end()
        next()
