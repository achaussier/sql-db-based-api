'use strict'

###*
 * @fileoverview Stats config
###

nodeEnv = process.env['NODE_ENV']

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    stats: (api) ->

        ###*
         * how often should the server write its stats to redis?
         * @type {Number}
        ###
        writeFrequency: 1000

        ###*
         * what redis key(s) [hash] should be used to store stats?
         * provide no key if you do not want to store stats
         * @type {Array}
        ###
        keys: [
            nodeEnv + ':stats'
        ]

###*
 * Test stats configuration
 * @type {Object}
###
exports.test =
    stats: (api) ->
        ###*
         * how often should the server write its stats to redis?
         * @type {Number}
        ###
        writeFrequency: 0
