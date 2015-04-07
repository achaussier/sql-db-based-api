'use strict'

###*
# @fileOverview Intializer used to connect to MariaDB server with mysql driver
###

###*
# Required custom classess
###
DatabaseWrapper     = require '../../lib/class/DatabaseWrapper.js'
Maria10Database     = require '../../lib/class/Maria10Database.js'
Maria10QueryBuilder = require '../../lib/class/Maria10QueryBuilder.js'

###*
# Required modules
###
apiErrors       = require '../../lib/errors.js'
mysql           = require 'mysql'

###*
# Custom functions used with this initializer
###

###*
# Check if the dialect configured is managed by this initializer
# @param    {String}    dialect     Dialect in database configuration
# @return   {Boolean}               True if managed, else false
###
isDialectManaged = (dialect) ->
    if not dialect?
        false
    else if not /^mysql.*$/.test(dialect) and not /^maria.*$/.test(dialect)
        false
    else
        true

###*
# Get good class for this dialect (Database class and QueryBuilder class)
# @param    {String}    dialect     Dialect in database configuration
# @return   {Array}                 Database class and QueryBuilder class
# @throw    {Object}                ServerError if no Database class for dialect
###
getDialectClasses = (dialect) ->

    dbObj           = null
    queryBuilder    = null

    switch dialect
        when 'maria10'
            dbObj           = new Maria10Database()
            queryBuilder    = Maria10QueryBuilder

    if not dbObj?
        errorObj = new apiErrors.ServerError(
            dialect,
            'database-dialect-not-implemented'
        )
        return [errorObj, null]

    [dbObj, queryBuilder]

###*
# Initializer create
###
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

        ###*
        # Create namespace for query builder
        ###
        if not api.queryBuilder?
            api.queryBuilder = null

        next()

    start: (api, next) ->

        dialect = api?.config?.database?.dialect

        ###*
        # Only process this initializer for maria or mysql databases
        ###
        if not isDialectManaged dialect
            return next()

        ###*
        # Check if this database dialect is managed by this initializer
        ###
        [dbObj, queryBuilder] = getDialectClasses dialect

        if dbObj instanceof apiErrors.ServerError
            return next dbObj

        ###*
        # Create pools and wrap methods
        ###
        dbObj
            .generatePools(api.config.database)
            .then(
                (result) ->
                    wrapper                    = new DatabaseWrapper()
                    wrapper.getStructureQuery  = dbObj.getDatabaseStructureQuery
                    wrapper.getReadConnection  = dbObj.getReadConnection
                    wrapper.getWriteConnection = dbObj.getWriteConnection
                    wrapper.executeSelect      = dbObj.executeSelect
                    wrapper.end                = dbObj.poolCluster.end
                    api.database               = wrapper
                    api.queryBuilder           = queryBuilder
                    next()
                ,(error) ->
                    throw error
            )
            .catch (error) ->
                errorObj = new apiErrors.ServerError(
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
