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
            get: []
            post: []
            put: []
            delete: []

        ###*
         * @description Routes for GET verb
        ###


        ###*
         * @description Request to return true (allways authenticate)
        ###
        routesObj.get.push
            path: "/status"
            action: "status"

        routesObj
