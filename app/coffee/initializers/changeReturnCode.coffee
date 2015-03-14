'use strict'

###*
# @fileOverview Post processor to change return code if error key contains
# custom error objects
###

isArray = require('util').isArray

###*
# Change return code if errors exists
# @param {Object} connection Current request
# @param {Object} actionTemplate Template of action processed
# @param {Boolean} toRender Return response to user
# @param {Function} next Callback
###
changeReturnCode = (connection, actionTemplate, toRender, next) ->

    if isArray(connection.error) and not isNaN(connection.error[0]?.code)
        returnCode = connection.error[0].code
        connection.rawConnection.responseHttpCode = returnCode
        next connection, true
    else
        next connection, true

exports.changeReturnCode = changeReturnCode


###*
# Add preprocessor to API
###
exports.initialize = (api, next) ->
    api.actions.addPostProcessor changeReturnCode
    next()

