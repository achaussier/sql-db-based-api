'use strict'

###*
 * @fileoverview General API config
###

###*
 * @description Import constants
 * @type {Object}
###
config = require '../constants/config.js'
paths = config.paths


env = process.env
nodeEnv = env.NODE_ENV

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    general: (api) ->
        apiVersion: '4.0.0',
        serverName: 'RackMonkey API - ' + nodeEnv.toUpperCase()

        ###*
         * Id can be set here, or it will be generated dynamically.
         * Be sure that every server you run has a unique ID (which will happen
         * when generated dynamically)
         * @type {String}
        ###
        #id: 'myActionHeroServer'

        ###*
         * A unique token to your application that servers will use to
         * authenticate to each other
         * @type {String}
        ###
        serverToken: 'criteo_rackmonkey_api_' + nodeEnv.toLowerCase()

        ###*
         * The welcome message seen by TCP and webSocket clients upon connection
         * @type {String}
        ###
        welcomeMessage: 'Hello! Welcome to the ' + nodeEnv.toLowerCase() + '
                        RackMonkey api'

        ###*
         * The redis prefix for actionhero's cache objects
         * @type {String}
        ###
        cachePrefix: 'actionhero:cache:'

        ###*
         * The redis prefix for actionhero's cache/lock objects
         * @type {String}
        ###
        lockPrefix: 'actionhero:lock:'

        ###*
         * How long will a lock last before it exipres (ms)?
         * @type {Number}
        ###
        lockDuration: 1000 * 10 # 10 seconds

        ###*
         * Watch for changes in actions and tasks, and reload/restart them on
         * the fly
         * @type {Boolean}
        ###
        developmentMode: true

        ###*
         * How many pending actions can a single connection be working on
         * @type {Number}
        ###
        simultaneousActions: 5

        ###*
         * Disables the whitelisting of client params
         * @type {Boolean}
        ###
        disableParamScrubbing: true

        ###*
         * Params you would like hidden from any logs
         * @type {Array}
        ###
        filteredParams: []

        ###*
        # Values that signify missing params
        ###
        missingParamChecks: [null, '', undefined]

        ###*
         * The default filetype to server when a user requests a directory
         * @type {String}
        ###
        directoryFileType : 'index.html'

        ###*
         * The default priority level given to preProcessors, postProcessors,
         * createCallbacks, and destroyCallbacks
         * @type {Number}
        ###
        defaultMiddlewarePriority : 100

        ###*
         * Configuration for your actionhero project structure
         * @type {Object}
        ###
        paths:
            'action':      [ env['PROJECT_ROOT'] + paths.API_ACTIONS      ],
            'task':        [ env['PROJECT_ROOT'] + paths.API_TASKS        ],
            'public':      [ env['PROJECT_ROOT'] + paths.API_PUBLIC       ],
            'pid':         [ env['PROJECT_ROOT'] + paths.API_PIDS         ],
            'log':         [ env['PROJECT_ROOT'] + paths.API_LOGS         ],
            'server':      [ env['PROJECT_ROOT'] + paths.API_SERVERS      ],
            'initializer': [ env['PROJECT_ROOT'] + paths.API_INITIALIZERS ],
            'plugin':      [ env['PROJECT_ROOT'] + paths.API_PLUGINS      ]

        ###*
         * List of actionhero plugins you want to load
         * This is a list of plugin names
         * Plugin still need to be included in `package.json` or the path
         * defined in `api.config.general.paths.plugin`
         * @type {Array}
        ###
        plugins: []

        ###*
         * Hash containing chat rooms you wish to be created at server boot
         * @type {Object}
        ###
        startingChatRooms: {}

        ###*
         * Enable domains for actions
        ###
        actionDomains: true

###*
 * Specific configuration for local environment
 * @type {Object}
###
exports.local =
    general: (api) ->
        developmentMode: false

###*
 * Specific configuration for production environment
 * @type {Object}
###
exports.production =
    general: (api) ->
        developmentMode: false

###*
 * Specific configuration for test environment
 * @type {Object}
###
exports.test =
    general: (api) ->
        developmentMode: false
