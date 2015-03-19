'use strict'

###*
# @fileDescription Initializer which generate the database structure
###

dbStructUtils   = require '../../lib/databaseStructure.js'
inspect         = require('util').inspect
rmErrors        = require '../../lib/errors.js'
Q               = require 'q'

module.exports =
    loadPriority:  1000
    startPriority: 1000
    stopPriority:  1000

    initialize: (api, next) ->
        ###*
        # Initialize namespace to store database structure
        ###
        if not api.dbStructure?
            api.dbStructure = {}

        api.dbStructure.data             = {}
        api.dbStructure.versionOneRender = {}

        next()

    start: (api, next) ->
        ###*
        # If not database config to use, exit with an error
        ###
        if not api.config.database?
            errorObj = new rmErrors.ServerError(
                'bad-database-config',
                'bad-config'
            )
            next errorObj

        else
            ###*
            # A database config exists, so build the database structure
            ###
            dbStructUtils.getStructureFromDB api
                .then dbStructUtils.processDatabaseStructureParts
                .then (dbStructure) ->

                    ###*
                    # Store DatabaseStructure instance
                    ###
                    api.dbStructure.data = dbStructure

                    ###*
                    # Generate render for v1 backward compatibility an store it
                    ###
                    renderV1 = dbStructure.versionOneRender()
                    api.dbStructure.versionOneRender = renderV1
                    next()

                .catch (error) ->
                    next error

    stop: (api, next) ->
        next()
