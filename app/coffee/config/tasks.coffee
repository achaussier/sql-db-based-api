'use strict'

###*
 * @fileoverview Tasks config
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    tasks: (api) ->
        ###*
         * Should this node run a scheduler to promote delayed tasks?
         * @type {Boolean}
        ###
        scheduler: false

        ###*
         * What queues should the workers work and how many to spawn?
         * ['*'] is one worker working the * queue
         * ['high,low'] is one worker working 2 queues
         * @type {Array}
        ###
        queues: ['*']

        ###*
         * How long to sleep between jobs / scheduler checks
         * @type {Number}
        ###
        timeout: 5000

        ###*
         * At minimum, how many parallel taskProcessors should this node spawn?
         * (have number > 0 to enable, and < 1 to disable)
        ###
        minTaskProcessors: 0

        ###*
         * At maximum, how many parallel taskProcessors should this node spawn?
        ###
        maxTaskProcessors: 0

        ###*
         * How often should we check the event loop to spawn more
         * taskProcessors?
        ###
        checkTimeout: 500

        ###*
         * How many ms would constitue an event loop delay to halt
         * taskProcessors spawning?
        ###
        maxEventLoopDelay: 5

        ###*
         * When we kill off a taskProcessor, should we disonnect that local
         * redis connection?
        ###
        toDisconnectProcessors: true

        ###*
         * What redis server should we connect to for tasks / delayed jobs?
         * @type {Object}
        ###
        redis: api.config?.redis
