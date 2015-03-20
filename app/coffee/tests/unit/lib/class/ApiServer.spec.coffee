'use strict'

###*
# @fileOverview Tests about ApiServer class
###

# require packages
clone       = require 'clone'
fs          = require 'fs'
mocks       = require '../../_mocks.js'
ApiServer   = require '../../../../lib/class/ApiServer.js'
sinon       = require 'sinon'
should      = require 'should'

errorObj    = null
helpContent = null
mocksUtils  = null
sigintListener = null
spy         = null
stub        = null
stub2       = null
val         = null

describe 'Main : ApiServer class', ->

    beforeEach (done) ->
        errorObj    = null
        helpContent = null
        mocksUtils  = clone mocks
        stub        = null
        stub2       = null
        val         = null
        done()

    afterEach (done) ->
        spy.restore()   if spy?.restore?
        stub.restore()  if stub?
        stub2.restore() if stub2?
        done()

    it 'should create new ApiServer', ->
        val = new ApiServer()
        val.should.be.instanceof ApiServer
        val.should.have.keys [
            '_start'
            'initializers'
            'api'
            'args'
        ]

    describe 'displayHelp', (done) ->
        beforeEach (done) ->
            errorObj    = null
            helpContent = null
            mocksUtils  = clone mocks
            spy         = null
            stub        = null
            stub2       = null
            val         = null
            done()

        afterEach (done) ->
            spy.restore()   if spy?.restore?
            stub.restore()  if stub?
            stub2.restore() if stub2?
            done()

        it 'should not display help file content', ->
            spy = sinon.spy(
                fs,
                'readFile'
            )
            val = new ApiServer()
            val.should.be.instanceof ApiServer
            helpContent = val.displayHelp()
            should.not.exists helpContent
            spy.called.should.be.false

        it 'should not display help file content', ->
            spy = sinon.spy(
                fs,
                'readFile'
            )
            val = new ApiServer()
            val.should.be.instanceof ApiServer
            helpContent = val.displayHelp('../../../help.txt')
            should.not.exists helpContent
            spy.called.should.be.true

    describe 'sigintListener', ->
        beforeEach (done) ->
            errorObj    = null
            helpContent = null
            mocksUtils  = clone mocks
            sigintListener = null
            spy         = null
            stub        = null
            stub2       = null
            val         = null
            done()

        afterEach (done) ->
            spy.restore()           if spy?.restore?
            stub.restore()          if stub?
            stub2.restore()         if stub2?
            process.exit.restore()  if process.exit.restore?
            done()

        it 'should add a listener', ->
            val = new ApiServer()
            val.should.be.instanceof ApiServer
            sigintListener = val.sigintListener(mocksUtils.api)
            sigintListener.should.have.property 'env'

        ###*
        # @todo Test need to be fixed
        #
        it 'should listen SIGINT', (done) ->
            val = new ApiServer()
            #val._start (error, api) ->
            stub = sinon.stub(
                process,
                'exit'
            )
            process.emit('SIGINT')
            done()
        ###

    describe '_start', ->
        beforeEach (done) ->
            errorObj    = null
            helpContent = null
            mocksUtils  = clone mocks
            spy         = null
            stub        = null
            stub2       = null
            val         = null
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

