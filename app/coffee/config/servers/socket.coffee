'use strict'

###*
 * @fileoverview Socket server config
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    servers:
        socket: (api) ->
            ###*
             * Server active or not
             * @type {Boolean}
            ###
            enabled: false

            ###*
             * TCP or TLS?
             * @type {Boolean}
            ###
            secure: false

            ###*
             * Passed to tls.createServer if secure=true. Should contain SSL
             * certificates
             * @type {Object}
            ###
            serverOptions: {}

            ###*
             * Port or Socket
             * @type {Number}
            ###
            port: 5000

            ###*
             * Which IP to listen on (use 0.0.0.0 for all)
             * @type {String}
            ###
            bindIP: '0.0.0.0'

            ###*
             * Enabple TCP KeepAlive pings on each connection?
             * @type {Boolean}
            ###
            setKeepAlive: false
