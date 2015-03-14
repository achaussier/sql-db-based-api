'use strict'

###*
# @fileOverview Tests about changeReturnCode post processor
###

# require packages
postProcessor = require '../../../../initializers/post/changeReturnCode.js'
mocks = require '../../_mocks.js'
should = require 'should'
sinon = require 'sinon'

mocksUtils = undefined
val = null
cb = null

describe 'Post processor : changeReturnCode', ->

    beforeEach (done) ->
        cb = sinon.spy()
        mocksUtils = Object.create mocks
        val = null
        done()

    it 'should be load', ->
        postProcessor.initialize mocksUtils.api, cb
        cb.calledOnce.should.be.true

    it 'should be change return code if a custom error code exists', ->
        postProcessor.changeReturnCode(
            mocksUtils.connectionWithErrorArray,
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].rawConnection.responseHttpCode.should.be.eql 666

    it 'should not change return code if a custom error code not exists', ->
        postProcessor.changeReturnCode(
            { error: 'foo' },
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.not.have.key 'rawConnection'
