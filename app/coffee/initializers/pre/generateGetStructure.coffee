'use strict'

###*
# @fileOverview Pre processor to generate a GenericGetStructure if action is
# genericGet
###

###*
# Generate GetStructure instance
# @param {Object}   connection      Current request
# @param {Object}   actionTemplate  Template of action processed
# @param {Function} next            Callback
###
generateGetStructure = (connection, actionTemplate, next) ->
    next connection, true

exports.generateGetStructure = generateGetStructure


###*
# Add preprocessor to API
###
exports.initialize = (api, next) ->
    api.actions.addPreProcessor generateGetStructure
    next()
