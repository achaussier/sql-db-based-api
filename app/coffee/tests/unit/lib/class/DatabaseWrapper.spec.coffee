'use strict'

###*
# @fileOverview Tests about DatabaseWrapper class
###

###*
# Required modules
###
DatabaseWrapper = require '../../../../lib/class/DatabaseWrapper.js'
apiErrors       = require '../../../../lib/errors.js'
should          = require 'should'

###*
# Declare variables
###
dbWrapper = undefined


describe 'Database management : DatabaseWrapper class', ->

    beforeEach (done) ->
        dbWrapper = new DatabaseWrapper()
        done()

    ###*
    # Check new instance create
    ###
    it 'should create new wrapper', ->
        dbWrapper.should.be.instanceof DatabaseWrapper

    ###*
    # Check native method call
    ###
    it 'should return an error with origin method', ->
        dbWrapper.getReadConnection()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check native method call
    ###
    it 'should return an error with origin method', ->
        dbWrapper.getWriteConnection()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check native method call
    ###
    it 'should return an error with origin method', ->
        dbWrapper.executeSelect()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )
