'use strict'

###*
# @fileOverview Action to return generic data
###

exports.genericGet =
    name            : 'genericGet'
    description     : 'Execute request if object exists'
    outputExample   :
        id      : 12
        name    : 'foo'

    ###*
    # Execute genericGet action
    # @param {Object}   api             Main application object
    # @param {Object}   connection      Current request
    # @param {Function} next            Callback
    ###
    run: (api, connection, next) ->
        next(connection, true)
