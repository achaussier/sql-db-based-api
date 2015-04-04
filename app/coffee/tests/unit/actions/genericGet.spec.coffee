'use strict'

###*
# @fileOverview Unit tests for status action
###

###*
# Required modules
###
actionObj   = require '../../../actions/genericGet.js'
clone       = require 'clone'
mocks       = require '../_mocks.js'
should      = require 'should'

###*
# Declare variables
###
mocksUtils  = undefined
val         = undefined

describe 'Action : generic GET', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        val         = undefined
        done()

    it 'should be loaded', ->
        actionObj.should.be.have.keys 'genericGet'
        actionObj.genericGet.should.have.properties [
            'name'
            'run'
        ]

    it 'should be requested', ->
        actionObj.genericGet.run mocksUtils.api, mocksUtils.connection, (connection, toRender) ->
            should.exists(connection.response)
            toRender.should.be.true
