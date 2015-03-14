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
            errors = []
            errors.push(
                new rmErrors.ServerError(null)
            )
            errors

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
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    action,
                    'unknown-action-or-invalid-api-version',
                    501
                )
            )
            errors

        ###*
         * Action not useable by this client/server type
         * @type {Function}
        ###
        unsupportedServerType: (type) ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    type,
                    'unsupported-server-type',
                    501
                )
            )
            errors

        ###*
         * Action failed because server is mid-shutdown
         * @type {Function}
        ###
        serverShuttingDown: ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'server-shutting-down',
                    503
                )
            )
            errors

        ###*
         * Action failed because this client already has too many pending
         * acitons limit defined in api.config.general.simultaneousActions
         * @type {Function}
        ###
        tooManyPendingActions: ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'too-many-pending-requests',
                    509
                )
            )
            errors

        ###*
         * A poorly designed action could try to call next() more than once
         * @type {Function}
        ###
        doubleCallbackError: ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'double-callback-prevented'
                )
            )
            errors

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
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'file-not-found',
                    404
                )
            )
            errors

        ###*
         * User didn't request a file
         * @type {Function}
        ###
        fileNotProvided: ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'no-file-parameter',
                    400
                )
            )
            errors

        ###*
         * User requested a file not in api.config.paths.public
         * @type {Function}
        ###
        fileInvalidPath: ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    null,
                    'incorrect-file-path',
                    422
                )
            )
            errors

        ###*
         * Something went wrong trying to read the file
         * @type {Function}
        ###
        fileReadError: (err) ->
            errors = []
            errors.push(
                new rmErrors.ServerError(
                    err,
                    'error-reading-file',
                    424
                )
            )
            errors

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
