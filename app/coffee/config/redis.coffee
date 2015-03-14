'use strict'

###*
 * @fileoverview Redis config
###

###*
 * @description You can use many types redis connection packages, including:
 * node redis | https://github.com/mranney/node_redis
 * fake redis | https://github.com/hdachev/fakeredis
 * sentinel redis | https://github.com/ortoo/node-redis-sentinel
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    redis: (api) ->

        ###*
         * Which channel to use on redis pub/sub for RPC communication
         * @type {String}
        ###
        channel: 'actionhero'

        ###*
         * How long to wait for an RPC call before considering it a failure
         * @type {Number}
        ###
        rpcTimeout: 5000

        ###*
         * Package to use
         * @type {String}
        ###
        package: process.env['API_CONF_REDIS_PKG'] or 'fakeredis'

        ###*
         * Password
         * @type {string}
        ###
        password: process.env['API_CONF_REDIS_PASSWORD'] or null

        ###*
         * Redis options
         * @type {Object}
        ###
        options: null

        ###*
         * Redis host
         * @type {String}
        ###
        host: process.env['API_CONF_REDIS_HOST'] or '127.0.0.1'

        ###*
         * Redis port
         * @type {Number}
        ###
        port: 6379

        ###*
         * Database number
         * @type {Number}
        ###
        database: process.env['API_CONF_REDIS_DATABASE'] or 0
