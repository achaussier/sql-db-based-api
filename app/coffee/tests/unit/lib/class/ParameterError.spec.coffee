'use strict'

###*
# @fileOverview Tests about ParameterError class
###

###*
# Required custom classes
###
paramError = require '../../../../lib/class/ParameterError.js'

###*
# Required modules
###
should = require 'should'

###*
# Declare variables
###
errorObj = undefined

describe 'ParameterError', ->

    beforeEach (done) ->
        errorObj = null
        done()

    ###*
    # Check without message
    ###
    it 'should generate new error object without message param send', ->
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

    ###*
    # Check with message
    ###
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

    ###*
    # Check with a code
    ###
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

    ###*
    # Check with a category
    ###
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
