'use strict'

###*
# @fileOverview Class used to manage Mysql and MariaDB databases
# @class MysqlDatabase
###

###*
# Required modules
###
apiErrors   = require '../errors.js'
mysql       = require 'mysql'
Q           = require 'q'

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
        @dbName         = null
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
                throw new apiErrors.ServerError(
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
                    @poolCluster.add("MASTER#{index}", dbServer)

            ###*
            # Add slave servers
            ###
            for dbServer, index in databaseConfig.slaves
                do (dbServer, index) =>
                    dbServer.database = databaseConfig.dbName
                    @poolCluster.add("SLAVE#{index}", dbServer)

            ###*
            # Create a write pool and a read pool to split read/write
            ###
            @readPool   = @poolCluster.of('SLAVE*',  databaseConfig.selector)
            @writePool  = @poolCluster.of('MASTER*', databaseConfig.selector)

            @getReadConnection = () =>
                if not @readPool?
                    return Q.fcall ->
                        throw new apiErrors.ServerError(
                            @,
                            'no-mysql-read-pool'
                        )
                Q.nbind(@readPool.getConnection, @readPool)()

            @getWriteConnection = () =>
                if not @writePool?
                    return Q.fcall ->
                        throw new apiErrors.ServerError(
                            @,
                            'no-mysql-write-pool'
                        )
                Q.nbind(@writePool.getConnection, @writePool)()

            Q.fcall ->

        catch error
            Q.fcall ->
                throw new apiErrors.ServerError(
                    error,
                    'database-configuration-error'
                )

    ###*
    # Check params of executeSelect function
    # @param    {Object}    connection  Database connection
    # @param    {Object}    queryData   Query data (sql, option, values)
    # @return   {Boolean}               True if params are valid
    # @throw    {Object}                DatabaseError if parameter are not valid
    ###
    checkExecuteSelect: (connection, queryData) ->

        if not connection?
            errorObj = new apiErrors.ParameterError(
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
            errorObj = new apiErrors.ParameterError(
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
    executeSelect: (connection, queryData) =>
        defer = Q.defer()
        ###*
        # Verify if params are valid
        ###
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
                            errorObj = new apiErrors.DatabaseError(
                                {
                                    query   : queryData,
                                    error   : error
                                },
                                'error-during-query-execution'
                            )
                            return defer.reject errorObj

                        defer.resolve
                            results : results
                            fields  : fields

                ,(error) ->
                    defer.reject error
            )

        defer.promise

module.exports = MysqlDatabase
