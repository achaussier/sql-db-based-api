'use strict'

###*
# @fileOverview     This is the test file for Factory class
###

###*
# Required custom classes
###
Factory = require '../../../../lib/class/Factory.js'

###*
# Required modules
###
apiErrors   = require '../../../../lib/errors.js'
clone       = require 'clone'
mocks       = require '../../_mocks.js'
should      = require 'should'

###*
# Declare variables
###
factory     = undefined
factory1    = undefined
factory2    = undefined
mocksUtils  = undefined

describe 'Factory class', ->
    beforeEach (done) ->
        factory     = null
        mocksUtils  = clone mocks
        done()

    ###*
    # Check without param
    ###
    it 'should not instantiate an object without param', ->
        factory = new Factory()
        factory.should.be.instanceof Array
        factory[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with bad objectType
    ###
    it 'should not instantiate an object with bad objectType param', ->
        factory = new Factory(null, true, 'foobar')
        factory.should.be.instanceof Array
        factory[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with bad isGeneric
    ###
    it 'should not instantiate an object with bad isGeneric param', ->
        factory = new Factory('foo', null, 'foobar')
        factory.should.be.instanceof Array
        factory[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with bad factoryName
    ###
    it 'should not instantiate an object with bad isGeneric param', ->
        factory = new Factory('foo', null, null)
        factory.should.be.instanceof Array
        factory[0].should.be instanceof apiErrors.ParameterError

    ###*
    # Check with good params for generic factory
    ###
    it 'should instantiate an object', ->
        factory = new Factory('foo', true, 'foobar')
        factory.should.be.instanceof Factory
        factory.should.have.keys [
            'objType'
            'isGeneric'
            'name'
        ]
        factory.name.should.be.eql 'Foobar'
        factory.objType.should.be.eql 'Foo'
        factory.isGeneric.should.be.true

    ###*
    # Check with good params for a no generic factory
    ###
    it 'should instantiate an object', ->
        factory = new Factory('foo', false, 'foobar')
        factory.should.be.instanceof Factory
        factory.should.have.keys [
            'objType'
            'isGeneric'
            'name'
        ]
        factory.name.should.be.eql 'Foobar'
        factory.objType.should.be.eql 'Foo'
        factory.isGeneric.should.be.false

    ###*
    # Check to call a method from this abstract class
    ###
    it 'should reject if call a request method', ->
        factory = new Factory('foo', false, 'foobar')
        factory.get()
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
        factory = new Factory('foo', false, 'foobar')
        factory.post()
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
        factory = new Factory('foo', false, 'foobar')
        factory.put()
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
        factory = new Factory('foo', false, 'foobar')
        factory.patch()
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
        factory = new Factory('foo', false, 'foobar')
        factory.del()
            .then(
                (result) ->
                    throw new Error 'Should not be go here in this test'
                ,(error) ->
                    error.should.be.instanceof apiErrors.ServerError
            )

    describe 'getFactory', ->
        beforeEach (done) ->
            factory1    = null
            factory2    = null
            mocksUtils  = clone mocks
            done()

        ###*
        # check without param
        ###
        it 'should reject if bad params', ->
            Factory.getFactory()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # check with bad factories param
        ###
        it 'should reject if bad params', ->
            Factory.getFactory(null, 'Foo')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # check with bad factoryName param
        ###
        it 'should reject if bad params', ->
            Factory.getFactory([], null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # check with empty factories
        ###
        it 'should resolve with null', ->
            Factory.getFactory([], 'Foo')
                .then(
                    (result) ->
                        should.not.exists(result)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # check with existing factory
        ###
        it 'should resolve with factory', ->
            factory1        = clone mocksUtils.Factory
            factory2        = clone mocksUtils.Factory
            factory2.name   = 'Bar'
            Factory.getFactory([factory1, factory2], 'Foo')
                .then(
                    (result) ->
                        should.exists(result)
                        result.should.have.keys [
                            'name'
                            'objType'
                            'isGeneric'
                        ]
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # check with existing factory
        ###
        it 'should reject if multiple factories with same name', ->
            Factory.getFactory([mocksUtils.Factory, mocksUtils.Factory], 'Foo')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ServerError
                )
