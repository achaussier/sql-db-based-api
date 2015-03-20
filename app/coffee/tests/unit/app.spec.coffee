'use strict'

###*
# @fileOverview Tests about api start script
###

# require packages
clone       = require 'clone'
fs          = require 'fs'
mocks       = require './_mocks.js'
startScript = '../../app.js'
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

describe 'Main : API start script', ->

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

    it 'should be required', ->
        val = require startScript
        should.exists(val)
