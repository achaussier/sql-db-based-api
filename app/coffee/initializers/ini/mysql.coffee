'use strict'

###*
# @fileOverview Intializer used to connect to MariaDB server with mysql driver
###

mysql = require 'mysql'
rmErrors = require '../../lib/errors.js'

module.exports =
    loadPriority:  1000
    startPriority: 100
    stopPriority:  1000

    initialize: (api, next) ->

        ###*
        # Create namespace to manage mysql pools
        ###
        if api.database?
            api.database.mysql = {}
        else
            api.database =
                mysql: {}

        next()

    start: (api, next) ->

        errorObj = null

        try
            ###*
            # Create pool cluster with all servers
            ###
            poolCluster = mysql.createPoolCluster()
            poolCluster.add('MASTER_1', api.config.database)

            ###*
            # Create a write pool and a read pool to split read/write in future
            ###
            readPool = poolCluster.of('MASTER*', 'ORDER')
            writePool = poolCluster.of('MASTER*', 'ORDER')

            ###*
            # Attach server pools to api namespace
            ###
            api.database.mysql.poolCluster = poolCluster
            api.database.mysql.readPool    = readPool
            api.database.mysql.writePool   = writePool

        catch error
            errorObj = new rmErrors.ServerError(
                error,
                'database-connection-error'
            )
            errorObj

        finally

            ###*
            # If an error occurs, stop api launching
            ###
            next(errorObj)

    stop: (api, next) ->
        ###*
        # If api is stopping, disconnect from servers
        ###
        api.database.mysql.poolCluster.end()
        next()
