'use strict'

###*
# @fileOverview Script to start and stop api server
###

###*
# Required custom classes
###
ApiServer   = require './lib/class/ApiServer.js'

###*
# Required modules
###
apiErrors   = require './lib/errors.js'
helpFile    = './help.txt'
minimist    = require 'minimist'

###*
# Get all script params
###
args = minimist process.argv.slice 2

###*
# If this script is a require, return ApiServer class, else launch server
###
if require.main isnt module
    module.exports = ApiServer

else
    ###*
    # It's an execution via cli
    ###
    app = new ApiServer args

    ###*
    # If --help or -h param is set, display help and exit, else launch server
    ###
    if args.h or args.help
        return app.displayHelp(helpFile)

    ###*
    # Check environment variables
    ###
    if not process.env.ACTIONHERO_CONFIG?
        process.env.ACTIONHERO_CONFIG = __dirname + '/config'

    if not process.env.NODE_ENV?
        process.env.NODE_ENV = 'unknown'

    if not process.env.PROJECT_ROOT?
        process.env.PROJECT_ROOT = __dirname

    ###*
    # Start the server
    ###
    app._start (error, api) ->
        if error
            errorObj = new apiErrors.ServerError(
                error,
                'server-error-during-start'
            )
