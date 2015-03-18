'use strict'

###*
# @fileDescription Initializer which generate the database structure
###

dbStructUtils = require '../../lib/databaseStructure.js'
inspect = require('util').inspect
Q = require 'q'

module.exports =
    loadPriority:  1000
    startPriority: 1000
    stopPriority:  1000

    initialize: (api, next) ->

        ###*
        # Initialize namespace to store database structure
        ###
        if api.rackmonkey?
            api.rackmonkey.dbStructure =
                data: {}
                versionOneRender: {}
        else
            api.rackmonkey =
                dbStructure:
                    data: {}
                    versionOneRender: {}

        next()

    start: (api, next) ->

        dbStructUtils.getStructureFromDB api
            .then dbStructUtils.processDatabaseStructureParts
            .then (dbStructure) ->
                ###*
                # Store DatabaseStructure instance
                ###
                api.rackmonkey.dbStructure.data = dbStructure

                ###*
                # Generate render for v1 backward compatibility an store it
                ###
                renderV1 = dbStructure.versionOneRender()
                api.rackmonkey.dbStructure.versionOneRender = renderV1
                next()
            .catch (error) ->
                api.log inspect(error), 'error'
                next(error)
            .done()

    stop: (api, next) ->
        next()
