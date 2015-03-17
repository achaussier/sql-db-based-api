'use strict'

###*
 * @fileoverview Routes config
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    routes: (api) ->

        routesObj =
            get:    []
            post:   []
            put:    []
            delete: []

        ###*
         * GET : Request to return status of API
        ###
        routesObj.get.push
            path:   '/status'
            action: 'status'

        routesObj
