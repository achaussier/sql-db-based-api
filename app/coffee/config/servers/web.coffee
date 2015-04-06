'use strict'

###*
 * @fileoverview Web server config
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
    servers:
        web: (api) ->

            ###*
             * Server active or not
             * @type {Boolean}
            ###
            enabled: true

            ###*
             * HTTP or HTTPS?
             * @type {Boolean}
            ###
            secure: false

            ###*
             * Passed to https.createServer if secure=true. Should contain
             * SSL certificates
             * @type {Object}
            ###
            serverOptions: {}

            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 8080


            ###*
             * Which IP to listen on (use '0.0.0.0' for all; '::' for all on
             * ipv4 and ipv6)
             * Set to `null` when listening to socket
             * @type {String}
            ###
            bindIP: '127.0.0.1'

            ###*
             * Any additional headers you want actionhero to respond with
             * @type {Object}
            ###
            httpHeaders =
                'X-Powered-By'                  : api.config.general.serverName
                'Access-Control-Allow-Origin'   : '*'
                'Access-Control-Allow-Methods'  : 'HEAD,
                                                    GET,
                                                    POST,
                                                    PUT,
                                                    PATCH,
                                                    DELETE,
                                                    OPTIONS,
                                                    TRACE'
                'Access-Control-Allow-Headers'  : 'Content-Type,
                                                    Access-Control-Allow-Origin,
                                                    Authorization'


            ###*
             * Route that actions will be served from; secondary route against
             * this route will be treated as actions,
             * IE: /api/?action=test == /api/test/
             * @type {String}
            ###
            urlPathForActions : 'api'

            ###*
             * Route that static files will be served from;
             * path (relative to your project root) to serve static content from
             * set to `null` to disable the file server entirely
             * @type {String}
            ###
            urlPathForFiles : 'public'

            ###*
             * When visiting the root URL, should visitors see 'api' or 'file'?
             * Visitors can always visit /api and /public as normal
             * @type {String}
            ###
            rootEndpointType : 'api'

            ###*
             * Simple routing also adds an 'all' route which matches
             * /api/:action for all actions
             * @type {Boolean}
            ###
            simpleRouting : false

            ###*
             * queryRouting allows an action to be defined via a URL param,
             * ie: /api?action=:action
             * @type {Boolean}
            ###
            queryRouting : false

            ###*
             * The header which will be returned for all flat file served from
             * /public; defined in seconds
             * @type {Number}
            ###
            flatFileCacheDuration : 60

            ###*
             * Settings for determining the id of an http(s) request
             * (browser-fingerprint)
             * @type {Object}
            ###
            fingerprintOptions :
                cookieKey           : 'sessionID'
                toSetCookie         : true
                onlyStaticElements  : false
                settings:
                    path    : '/'
                    expires : 3600000

            ###*
             * Options to be applied to incoming file uploads.
            *  More options and details at
            *  https://github.com/felixge/node-formidable
             * @type {Object}
            ###
            formOptions:
                uploadDir       : '/tmp'
                keepExtensions  : false
                maxFieldsSize   : 1024 * 1024 * 100

            ###*
             * Should we pad JSON responses with whitespace to make them more
             * human-readable?
             * set to null to disable
             * @type {Number}
            ###
            padding: 2

            ###*
             * Options to configure metadata in responses
             * @type {Object}
            ###
            metadataOptions:
                serverInformation   : false
                requesterInformation: false

            ###*
             * When true, returnErrorCodes will modify the response header
             * for http(s) clients if connection.error is not null.
             *  You can also set connection.rawConnection.responseHttpCode to
             *   specify a code per request.
             * @type {Boolean}
            ###
            returnErrorCodes: true

###*
 * Local configuration
 * @type {Object}
###
exports.local =
    servers:
        web: (api) ->
            ###*
             * Which IP to listen on (use '0.0.0.0' for all; '::' for all on
             * ipv4 and ipv6)
             * Set to `null` when listening to socket
             * @type {String}
            ###
            bindIP: "0.0.0.0"

            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 9000

###*
 * Dev configuration
 * @type {Object}
###
exports.development =
    servers:
        web: (api) ->

            ###*
             * Options to configure metadata in responses
             * @type {Object}
            ###
            metadataOptions:
                serverInformation   : true
                requesterInformation: true

            ###*
             * Which IP to listen on (use '0.0.0.0' for all; '::' for all on
             * ipv4 and ipv6)
             * Set to `null` when listening to socket
             * @type {String}
            ###
            bindIP: "0.0.0.0"

            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 60000

###*
 * Preprod configuration
 * @type {Object}
###
exports.preprod =
    servers:
        web: (api) ->
            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 60001

###*
 * Production configuration
 * @type {Object}
###
exports.production =
    servers:
        web: (api) ->
            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 60002

###*
 * Test configuration
 * @type {Object}
###
exports.test =
    servers:
        web: (api) ->
            ###*
             * Port or Socket Path
             * @type {Number}
            ###
            port: 9000
