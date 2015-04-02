'use strict'

###*
# @fileOverview Tests about ServerError class
###

###*
# Require custom classes
###
serverError = require '../../../../lib/class/ServerError.js'

###*
# Require modules
###
should = require 'should'

###*
# Declare variables
###
errorObj = null

describe 'ServerError', ->

    beforeEach (done) ->
        errorObj = null
        done()

    ###*
    # Check with only data
    ###
    it 'should generate new error object with only data param send', ->
        errorObj = new serverError(
            'foobar'
        )
        errorObj.should.be.instanceof serverError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'internal-server-error'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'server-error'

    ###*
    # Check with massge
    ###
    it 'should set custom message', ->
        errorObj = new serverError(
            'foobar',
            'foo-server-error'
        )
        errorObj.should.be.instanceof serverError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-server-error'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'server-error'

    ###*
    # Check with custom code
    ###
    it 'should set custom code', ->
        errorObj = new serverError(
            'foobar',
            'foo-server-error',
            550
        )
        errorObj.should.be.instanceof serverError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-server-error'
        errorObj.code.should.be.eql 550
        errorObj.category.should.be.eql 'server-error'

    ###*
    # Check with category
    ###
    it 'should set custom category', ->
        errorObj = new serverError(
            'foobar',
            'foo-server-error',
            500,
            'foo'
        )
        errorObj.should.be.instanceof serverError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-server-error'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'foo'
