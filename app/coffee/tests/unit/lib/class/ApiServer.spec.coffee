'use strict'

###*
# @fileOverview Tests about ApiServer class
###

###*
# require packages
###
clone       = require 'clone'
fs          = require 'fs'
mocks       = require '../../_mocks.js'
ApiServer   = require '../../../../lib/class/ApiServer.js'
sinon       = require 'sinon'
should      = require 'should'

###*
# Declare variables
###
errorObj        = undefined
helpContent     = undefined
mocksUtils      = undefined
server          = undefined
sigintListener  = undefined
spy             = undefined
stub            = undefined
stub2           = undefined

describe 'Main : ApiServer class', ->

    beforeEach (done) ->
        errorObj    = null
        helpContent = null
        mocksUtils  = clone mocks
        server      = null
        stub        = null
        stub2       = null
        done()

    afterEach (done) ->
        spy.restore()   if spy?.restore?
        stub.restore()  if stub?
        stub2.restore() if stub2?
        done()

    ###*
    # Check new instance create
    ###
    it 'should create new ApiServer', ->
        server = new ApiServer()
        server.should.be.instanceof ApiServer
        server.should.have.keys [
            '_start'
            'initializers'
            'api'
            'args'
        ]

    describe 'displayHelp', (done) ->
        beforeEach (done) ->
            helpContent = null
            mocksUtils  = clone mocks
            server      = null
            spy         = null
            done()

        afterEach (done) ->
            spy.restore()   if spy?.restore?
            stub.restore()  if stub?
            stub2.restore() if stub2?
            done()

        ###*
        # Check without help file
        ###
        it 'should not display help file content', ->
            spy = sinon.spy(
                fs,
                'readFile'
            )
            server      = new ApiServer()
            helpContent = server.displayHelp()
            should.not.exists helpContent
            spy.called.should.be.false

        ###*
        # Check with help file
        ###
        it 'should display help file content', ->
            spy = sinon.spy(
                fs,
                'readFile'
            )
            server = new ApiServer()
            helpContent = server.displayHelp('../../../help.txt')
            should.not.exists helpContent
            spy.called.should.be.true

    describe 'sigintListener', ->
        beforeEach (done) ->
            mocksUtils      = clone mocks
            sigintListener  = null
            server          = null
            spy             = null
            stub            = null
            done()

        afterEach (done) ->
            spy.restore()           if spy?.restore?
            stub.restore()          if stub?
            stub2.restore()         if stub2?
            process.exit.restore()  if process.exit.restore?
            done()

        ###*
        # Check adding a listener
        ###
        it 'should add a listener', ->
            server          = new ApiServer()
            sigintListener  = server.sigintListener(mocksUtils.api)
            sigintListener.should.have.property 'env'

        ###*
        # @todo Test need to be fixed
        #
        it 'should listen SIGINT', (done) ->
            server = new ApiServer()
            #server._start (error, api) ->
            stub = sinon.stub(
                process,
                'exit'
            )
            process.emit('SIGINT')
            done()
        ###

    describe '_start', ->
        beforeEach (done) ->
            mocksUtils  = clone mocks
            server      = null
            spy         = null
            stub        = null
            stub2       = null
            done()

        afterEach (done) ->
            spy.restore()   if spy?.restore?
            stub.restore()  if stub?
            stub2.restore() if stub2?
            done()

        ###*
        # @todo Test need to be fixed

        it 'should be run start with a custom config file', (done) ->
            val = new ApiServer({ config: __dirname + '/../_fake_server_config.js' })
            val._start (error, api) ->
                val.stop()
                done()
        ###

