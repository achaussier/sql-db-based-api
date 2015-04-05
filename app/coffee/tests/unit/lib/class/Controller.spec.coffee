'use strict'

###*
# @fileOverview     This is the test file for Controller class
###

###*
# Required custom classes
###
Controller = require '../../../../lib/class/Controller.js'

###*
# Required modules
###
apiErrors   = require '../../../../lib/errors.js'
clone       = require 'clone'
mocks       = require '../../_mocks.js'

###*
# Declare variables
###
controller = undefined
mocksUtils = undefined

describe 'Controller class', ->
    beforeEach (done) ->
        controller = null
        mocksUtils = clone mocks
        done()

    ###*
    # Check without param
    ###
    it 'should not instantiate an object without param', ->
        controller = new Controller()
        controller.should.be.instanceof Array
        controller[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with bad objectType
    ###
    it 'should not instantiate an object with bad objectType param', ->
        controller = new Controller(null, true)
        controller.should.be.instanceof Array
        controller[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with bad isGeneric
    ###
    it 'should not instantiate an object with bad isGeneric param', ->
        controller = new Controller('foo', null)
        controller.should.be.instanceof Array
        controller[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with good params for generic controller
    ###
    it 'should instantiate an object', ->
        controller = new Controller('foo', true)
        controller.should.be.instanceof Controller
        controller.should.have.keys [
            'objType'
            'isGeneric'
            'name'
        ]
        controller.name.should.be.eql 'GenericFoo'
        controller.objType.should.be.eql 'Foo'
        controller.isGeneric.should.be.true

    ###*
    # Check with good params for a no generic controller
    ###
    it 'should instantiate an object', ->
        controller = new Controller('foo', false)
        controller.should.be.instanceof Controller
        controller.should.have.keys [
            'objType'
            'isGeneric'
            'name'
        ]
        controller.name.should.be.eql 'Foo'
        controller.objType.should.be.eql 'Foo'
        controller.isGeneric.should.be.false

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        controller = new Controller('foo', false)
        controller.get()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        controller = new Controller('foo', false)
        controller.post()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        controller = new Controller('foo', false)
        controller.put()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        controller = new Controller('foo', false)
        controller.patch()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        controller = new Controller('foo', false)
        controller.del()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )
