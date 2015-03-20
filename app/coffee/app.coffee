'use strict'

###*
# @fileOverview Script to start and stop api server
###

ApiServer   = require './lib/ApiServer.js'
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
        app.displayHelp(helpFile)

    else
        ###*
        # Start the server
        ###
        app._start (error, api) ->
            if error
                errorObj = new rmErrors.ServerError(
                    error,
                    'server-error-during-start'
                )

