'use strict'

###*
# @fileOverview Tests about changeReturnCode post processor
###

###*
# Required modules
###
postProcessor   = require '../../../../initializers/post/changeReturnCode.js'
mocks           = require '../../_mocks.js'
should          = require 'should'
sinon           = require 'sinon'

###*
# Declare variables
###
cb          = undefined
mocksUtils  = undefined

describe 'Post processor : changeReturnCode', ->

    beforeEach (done) ->
        cb          = sinon.spy()
        mocksUtils  = Object.create mocks
        done()

    ###*
    # Check load
    ###
    it 'should be load', ->
        postProcessor.initialize mocksUtils.api, cb
        cb.calledOnce.should.be.true

    ###*
    # Check with an array of errors
    ###
    it 'should be change return code', ->
        postProcessor.changeReturnCode(
            mocksUtils.connectionWithErrorArray,
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].rawConnection.responseHttpCode.should.be.eql 666

    ###*
    # Check with an array of errors but with null value
    ###
    it 'should not change return code', ->
        mocksUtils.connectionWithErrorArray.error[0] = null
        postProcessor.changeReturnCode(
            mocksUtils.connectionWithErrorArray,
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.not.have.key 'rawConnection'

    ###*
    # Check with an error object
    ###
    it 'should be change return code', ->
        postProcessor.changeReturnCode(
            mocksUtils.connectionWithError,
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].rawConnection.responseHttpCode.should.be.eql 666

    ###*
    # Check with an error object but with null value
    ###
    it 'should not change return code', ->
        mocksUtils.connectionWithError.error = null
        postProcessor.changeReturnCode(
            mocksUtils.connectionWithError,
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.not.have.key 'rawConnection'

    ###*
    # CHeck without error code
    ###
    it 'should not change return code if a custom error code not exists', ->
        postProcessor.changeReturnCode(
            { error: 'foo' },
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.not.have.key 'rawConnection'

    ###*
    # CHeck without error
    ###
    it 'should not change return code if a custom error code not exists', ->
        postProcessor.changeReturnCode(
            { error: null },
            {},
            true,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.not.have.key 'rawConnection'
