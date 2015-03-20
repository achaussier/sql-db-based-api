'use strict'

###*
# @fileOverview ApiServer class
# @class ApiServer
###

ActionHero  = require('actionhero').actionheroPrototype
fs          = require 'fs'
rmErrors    = require './errors.js'


class ApiServer extends ActionHero

    ###*
    # Constructor use to create new ApiServer objects
    # @constructor
    # @param    {Object} args       Arguments sent if exists
    # @return   {Object}            New ApiServer object
    ###
    constructor: (args) ->
        super
        @args = args or null

    ###*
    # Display help to user
    ###
    displayHelp: (helpFile) ->
        ###*
        # If no help file, return to cli
        ###
        if not helpFile
            console.log 'Sorry, no help file for app !'

        else
            ###*
            # If help file, diplay help
            ###
            fs.readFile helpFile, { encoding: 'utf8' }, (error, content) ->
                if error
                    return console.log 'Error occurs when open help file'

                console.log '\n\n', content

    ###*
    # Add a listener for the SIGINT event
    # @return   {Object}    api     Main api object
    # @throw    {Object}    ServerError if config file could not read
    # @todo                 Add validate config method
    ###
    sigintListener: (api) ->
        process.on 'SIGINT', =>
            api.log 'Got SIGINT. Stopping api server now !', 'info'

            @stop (error) ->
                if error
                    errorObj = new rmErrors.ServerError(
                        error,
                        'server-error-during-stop'
                    )
                    console.log errorObj
                process.exit()

    ###*
    # Start api server
    # @return   {}          Api server
    # @throw    {Object}    ServerError if error occured during start
    ###
    _start: =>

        ###*
        # Load configuration file if sent
        ###
        configFile = @args?.c or @args?.config

        if configFile
            config = require configFile
            @start config, (error, api) =>
                api.log 'Start with custum config file', 'info'
                @sigintListener(api)
        else
            @start (error, api) =>
                api.log 'Start without custum config file', 'info'
                @sigintListener(api)

module.exports = ApiServer
