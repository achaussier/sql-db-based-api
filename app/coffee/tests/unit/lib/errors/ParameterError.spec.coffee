'use strict'

###*
# @fileOverview Tests about ParameterError class
###

# require packages
paramError = require '../../../../lib/errors/ParameterError.js'
should = require 'should'

errorObj = null

describe 'ParameterError', ->

    beforeEach (done) ->
        errorObj = null
        done()

    it 'should generate new error object with only message param send', ->
        errorObj = new paramError(
            'username',
            'string',
            'array'
        )
        errorObj.should.be.instanceof paramError
        errorObj.name.should.be.eql 'username'
        errorObj.expected.should.be.eql 'string'
        errorObj.received.should.be.eql 'array'
        errorObj.message.should.be.eql 'bad-parameter-received'
        errorObj.code.should.be.eql 400
        errorObj.category.should.be.eql 'parameter-error'

    it 'should set custom message', ->
        errorObj = new paramError(
            'username',
            'string',
            'array',
            'bad-username-parameter'
        )
        errorObj.should.be.instanceof paramError
        errorObj.name.should.be.eql 'username'
        errorObj.expected.should.be.eql 'string'
        errorObj.received.should.be.eql 'array'
        errorObj.message.should.be.eql 'bad-username-parameter'
        errorObj.code.should.be.eql 400
        errorObj.category.should.be.eql 'parameter-error'

    it 'should set custom code', ->
        errorObj = new paramError(
            'username',
            'string',
            'array',
            'bad-username-parameter',
            500
        )
        errorObj.should.be.instanceof paramError
        errorObj.name.should.be.eql 'username'
        errorObj.expected.should.be.eql 'string'
        errorObj.received.should.be.eql 'array'
        errorObj.message.should.be.eql 'bad-username-parameter'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'parameter-error'

    it 'should set custom category', ->
        errorObj = new paramError(
            'username',
            'string',
            'array',
            'bad-username-parameter',
            500,
            'foo'
        )
        errorObj.should.be.instanceof paramError
        errorObj.name.should.be.eql 'username'
        errorObj.expected.should.be.eql 'string'
        errorObj.received.should.be.eql 'array'
        errorObj.message.should.be.eql 'bad-username-parameter'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'foo'
