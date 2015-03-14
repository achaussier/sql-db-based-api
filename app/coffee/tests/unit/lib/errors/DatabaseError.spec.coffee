'use strict'

###*
# @fileOverview Tests about DatabaseError class
###

# require packages
DatabaseError = require '../../../../lib/errors/DatabaseError.js'
should = require 'should'

errorObj = null

describe 'DatabaseError', ->

    beforeEach (done) ->
        errorObj = null
        done()

    it 'should generate new error object with only data param send', ->
        errorObj = new DatabaseError(
            'foobar'
        )
        errorObj.should.be.instanceof DatabaseError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'query-error'
        errorObj.code.should.be.eql 400
        errorObj.category.should.be.eql 'database-error'

    it 'should set custom message', ->
        errorObj = new DatabaseError(
            'foobar',
            'foo-database-error'
        )
        errorObj.should.be.instanceof DatabaseError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-database-error'
        errorObj.code.should.be.eql 400
        errorObj.category.should.be.eql 'database-error'

    it 'should set custom code', ->
        errorObj = new DatabaseError(
            'foobar',
            'foo-database-error',
            550
        )
        errorObj.should.be.instanceof DatabaseError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-database-error'
        errorObj.code.should.be.eql 550
        errorObj.category.should.be.eql 'database-error'

    it 'should set custom category', ->
        errorObj = new DatabaseError(
            'foobar',
            'foo-database-error',
            500,
            'foo'
        )
        errorObj.should.be.instanceof DatabaseError
        errorObj.data.should.be.eql 'foobar'
        errorObj.message.should.be.eql 'foo-database-error'
        errorObj.code.should.be.eql 500
        errorObj.category.should.be.eql 'foo'
