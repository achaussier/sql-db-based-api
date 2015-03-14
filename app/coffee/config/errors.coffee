'use strict'

###*
 * @fileoverview Errors config
###

rmErrors = require '../lib/errors.js'
###*
 * Default configuration
 * @type {Object}
###
exports.default =
    errors: (api) ->
        '_toExpand': false

        ###*
         * @description General errors
        ###

        ###*
         * The message to accompany general 500 errors (internal server errors)
         * @type {Function}
        ###
        serverErrorMessage: ->
            'The server experienced an internal error'

        ###*
         * @description Action errors
        ###

        ###*
         * When a params for an action is invalid
         * @type {Function}
        ###
        invalidParams: (params) ->
            errors = []
            for invalidParam in params
                errorObj = new rmErrors.ParameterError(
                    invalidParam,
                    undefined,
                    null,
                    'invalid-parameter'
                )
                errors.push errorObj
            errors
        ###*
         * When a required param for an action is not provided
         * @type {Function}
        ###
        missingParams: (params) ->
            errors = []
            for missingParam in params
                errorObj = new rmErrors.ParameterError(
                    missingParam,
                    undefined,
                    null,
                    'missing-parameter'
                )
                errors.push errorObj
            errors

        ###*
         * User requested an unknown action
         * @type {Function}
        ###
        unknownAction: (action) ->
            'unknown action or invalid apiVersion'

        ###*
         * Action not useable by this client/server type
         * @type {Function}
        ###
        unsupportedServerType: (type) ->
            'this action does not support the ' + type + ' connection type'

        ###*
         * Action failed because server is mid-shutdown
         * @type {Function}
        ###
        serverShuttingDown: ->
            'the server is shutting down'

        ###*
         * Action failed because this client already has too many pending
         * acitons limit defined in api.config.general.simultaneousActions
         * @type {Function}
        ###
        tooManyPendingActions: ->
            'you have too many pending requests'

        ###*
         * A poorly designed action could try to call next() more than once
         * @type {Function}
        ###
        doubleCallbackError: ->
            'Double callback prevented within action'

        ###*
         * @description Server file errors
        ###

        ###*
         * The body message to accompany 404 (file not found) errors regarding
         * flat files
         * You may want to load in the contnet of 404.html or similar
         * @type {Function}
        ###
        fileNotFound: ->
            'Sorry, that file is not found :('

        ###*
         * User didn't request a file
         * @type {Function}
        ###
        fileNotProvided: ->
            'file is a required param to send a file'

        ###*
         * User requested a file not in api.config.paths.public
         * @type {Function}
        ###
        fileInvalidPath: ->
            'that is not a valid file path'

        ###*
         * Something went wrong trying to read the file
         * @type {Function}
        ###
        fileReadError: (err) ->
            'error reading file: ' + String err

        ###*
         * @description Connection errors
        ###

        ###*
         * Verb used is incorrect
         * @type {Function}
        ###
        verbNotFound: (verb) ->
            'I do not know know to perform this verb'

        ###*
         * Verb used isn't allowed
         * @type {Function}
        ###
        verbNotAllowed: (verb) ->
            'verb not found or not allowed'

        ###*
         * Room and message are mandatory
         * @type {Function}
        ###
        connectionRoomAndMessage: ->
            'both room and message are required'

        ###*
         * Bad room
         * @type {Function}
        ###
        connectionNotInRoom: (room) ->
            'connection not in this room'

        ###*
         * Already in room
         * @type {Function}
        ###
        connectionAlreadyInRoom: (room) ->
            'connection already in this room'

        ###*
         * Deleted room
         * @type {Function}
        ###
        connectionRoomHasBeenDeleted: (room) ->
            'this room has been deleted'

        ###*
         * Room not exists
         * @type {Function}
        ###
        connectionRoomNotExist: (room) ->
            'room does not exist'

        ###*
         * Room already exists
         * @type {Function}
        ###
        connectionRoomExists: (room) ->
            'room exists'

        ###*
         * Room is mandatory
         * @type {Function}
        ###
        connectionRoomRequired: (room) ->
            'a room is required'
