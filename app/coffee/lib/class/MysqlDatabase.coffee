'use strict'

###*
# @fileOverview Class used to manage Mysql and MariaDB databases
# @class MysqlDatabase
###

###*
# Required modules
###
mysql       = require 'mysql'
Q           = require 'q'
rmErrors    = require '../errors.js'

###*
# Required methods
###
isArray             = require('util').isArray
isNotEmptyString    = require('../global').isNotEmptyString

class MysqlDatabase

    ###*
    # Constructor of MysqlDatabase class
    # @return   {Object}    A new relation object if params are valid
    ###
    constructor: () ->
        @clusterPool    = null
        @dbName       = null
        @readPool       = null
        @writePool      = null

    ###*
    # Check configuration for a server in database config
    # @param    {Object}    serverConfig    Server configuration object
    # @return   {Boolean}                   True if config is valid, else false
    ###
    checkServerConfiguration: (serverConfig) ->
        multiStat = serverConfig?.multipleStatements
        switch
            when not isNotEmptyString(serverConfig?.host)       then false
            when not isNotEmptyString(serverConfig.user)        then false
            when not isNotEmptyString(serverConfig.password)    then false
            when     typeof serverConfig.port isnt 'number'     then false
            when not (multiStat is true or multiStat is false)  then false
            else true

    ###*
    # Check params send to generatePools method
    # @param    {Object}    config  Database configuration
    # @return   {Boolean}           True if configuration is valid, else false
    ###
    checkGeneratePoolsParams: (config) ->

        ###*
        # Check level one keys
        ###
        mainStruct = switch
            when not isNotEmptyString(config?.dialect)  then false
            when not isNotEmptyString(config.dbName)    then false
            when not isNotEmptyString(config.selector)  then false
            when not isArray(config.masters)            then false
            when not isArray(config.slaves)             then false
            else true

        if not mainStruct
            return false

        ###*
        # Check server config for masters and slaves
        ###
        serversConfig = true
        for type, servers of config when type is 'masters' or type is 'slaves'
            do (servers) =>
                for server in servers
                    do (server) =>
                        if not @checkServerConfiguration(server)
                            serversConfig = false
        serversConfig

    ###*
    # Generate server pools
    # @param    {Object}    databaseConfig  Api database configuration
    # @return   {}                          Nothing
    # @throw                                ServerError if error occurs
    ###
    generatePools: (databaseConfig) ->

        ###*
        # Check configuration received
        ###
        if not @checkGeneratePoolsParams databaseConfig
            return Q.fcall ->
                throw new rmErrors.ServerError(
                    databaseConfig,
                    'database-configuration-error'
                )

        try
            ###*
            # Define database name
            ###
            @dbName = databaseConfig.dbName

            ###*
            # Create pool cluster
            ###
            @poolCluster = mysql.createPoolCluster()

            ###*
            # Add master servers
            ###
            for dbServer, index in databaseConfig.masters
                do (dbServer, index) =>
                    dbServer.database = databaseConfig.dbName
                    @poolCluster.add('MASTER_#{index}', dbServer)

            ###*
            # Add slave servers
            ###
            for dbServer, index in databaseConfig.slaves
                do (dbServer, index) =>
                    dbServer.database = databaseConfig.dbName
                    @poolCluster.add('SLAVE_#{index}', dbServer)

            ###*
            # Create a write pool and a read pool to split read/write
            ###
            selector    = databaseConfig.selector
            @readPool   = @poolCluster.of('MASTER*', selector)
            @writePool  = @poolCluster.of('SLAVE*',  selector)

            Q.fcall ->

        catch error
            Q.fcall ->
                throw new rmErrors.ServerError(
                    error,
                    'database-configuration-error'
                )

    ###*
    # Return a promise connection from a read only pool
    # @return   {Function}  A connection from a read only pool
    # @throw    {Object}    A ParameterError Object if no read only pool
    ###
    getReadConnection: () ->

        ###*
        # Check if a read pool exists
        ###
        if not @readPool?
            errorObj = new rmErrors.ServerError(
                @,
                'no-mysql-read-pool'
            )
            return Q.fcall ->
                throw errorObj


        ###*
        # Return a promised version of pool.getConnection method
        ###
        @readPool.getConnection (error, roConnection) ->
            if error
                errorObj = new rmErrors.DatabaseError(
                    error,
                    'connection-error'
                )
                return Q.fcall ->
                    throw errorObj

            Q.fcall ->
                roConnection

    ###*
    # Return a promise connection from a write pool
    # @return   {Function}  A connection from a write pool
    # @throw    {Object}    A ParameterError Object if no write pool
    ###
    getWriteConnection: () ->

        ###*
        # Check if a write pool exists
        ###
        if not @writePool?
            errorObj = new rmErrors.ServerError(
                @,
                'no-mysql-write-pool'
            )
            return Q.fcall ->
                throw errorObj

        ###*
        # Return a promised version of pool.getConnection method
        ###
        @writePool.getConnection (error, writeConnection) ->
            if error
                errorObj = new rmErrors.DatabaseError(
                    error,
                    'connection-error'
                )
                return Q.fcall ->
                    throw errorObj

            Q.fcall ->
                writeConnection

    ###*
    # Check params of executeSelect function
    # @param    {Object}    connection  Database connection
    # @param    {Object}    queryData   Query data (sql, option, values)
    # @return   {Boolean}               True if params are valid
    # @throw    {Object}                DatabaseError if parameter are not valid
    ###
    checkExecuteSelect: (connection, queryData) ->

        if not connection?.query?
            errorObj = new rmErrors.ParameterError(
                'connection',
                'Object',
                connection
            )
            return Q.fcall ->
                throw errorObj

        if not isNotEmptyString(queryData?.sql) or not queryData.values?
            ###*
            # Check keys of queryData param and check the sql query isn't empty
            ###
            errorObj = new rmErrors.ParameterError(
                'queryData',
                'Object',
                queryData
            )
            return Q.fcall ->
                throw errorObj

        Q.fcall ->

    ###*
    # Execute select sql query
    # @param    {Object}    connection  Database connection
    # @param    {Object}    queryData   Query data (sql, option, values)
    # @return   {Object}                Database result fo this query and fields
    # @throw    {Object}                DatabaseError if error during query
    # @throw    {Object}                ParameterError if invalid params
    ###
    executeSelect: (connection, queryData) ->

        ###*
        # Verify if params are valid
        ###
        @checkExecuteSelect connection, queryData
            .then(
                (result) ->
                    connection.query queryData, (error, results, fields) ->

                        ###*
                        # If error occurs during query, reject it
                        ###
                        if error
                            errorObj = new rmErrors.DatabaseError(
                                {
                                    query   : queryData,
                                    error   : error
                                },
                                'error-during-query-execution'
                            )
                            return Q.fcall ->
                                throw errorObj

                        Q.fcall ->
                            results : results
                            fields  : fields

                ,(error) ->
                    throw error
            )

module.exports = MysqlDatabase
