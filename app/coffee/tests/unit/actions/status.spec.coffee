'use strict'

###*
# @fileOverview Unit tests for status action
###

# require packages
should = require 'should'
actionObj = require '../../../actions/status.js'
mocks = require '../_mocks.js'

# declare variables
mocksUtils = undefined
val = undefined

describe 'Action : API status', ->

    beforeEach (done) ->
        mocksUtils = Object.create mocks
        val = undefined
        done()

    it 'should be loaded', ->
        actionObj.should.be.have.keys 'status'
        actionObj.status.should.have.properties [
            'name'
            'run'
        ]

    it 'should be requested', ->
        actionObj.status.run mocksUtils.api, mocksUtils.connection, (connection, toRender) ->
            connection.response.actionheroVersion.should.be.eql 'foo'
            connection.response.id.should.be.eql 'bar'
            connection.response.queues.should.be.eql 'foo'
            connection.response.workers.should.be.eql 'bar'
            toRender.should.be.true
