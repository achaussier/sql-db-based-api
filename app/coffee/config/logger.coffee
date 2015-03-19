'use strict'

###*
 * @fileoverview Logger config
###

fs      = require 'fs'
cluster = require 'cluster'
winston = require 'winston'

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    logger: (api) ->

        ###*
        # Initialize transports for logger
        ###
        logger =
            transports: []

        ###*
        # Active transports
        ###
        logger.transports.push (api, winston) ->
            new (winston.transports.Console)(
                colorize    : true
                level       : 'debug'
                timestamp   : api.utils.sqlDateTime
            )

        logger

###*
 * Local configuration
 * @type {Object}
###
exports.local =
  logger: (api) ->
      transports: []

###*
 * Production configuration
 * @type {Object}
###
exports.production =
    logger: (api) ->

        ###*
        # Initialize transports for logger
        ###
        logger =
            transports: []

        ###*
        # Active transports
        ###
        logger.transports.push (api, winston) ->
            new (winston.transports.Console)(
                colorize    : true
                level       : 'info'
                timestamp   : api.utils.sqlDateTime
            )

        logger
