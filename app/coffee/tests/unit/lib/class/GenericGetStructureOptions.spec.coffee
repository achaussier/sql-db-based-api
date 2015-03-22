'use strict'

###*
# @fileOverview Test file for GenericGetStructureOptions class
###

# require packages
DatabaseStructure           = require '../../../../lib/class/DatabaseStructure.js'
GenericGetStructureOptions  = require '../../../../lib/class/GenericGetStructureOptions.js'
GenericGetStructureOrder    = require '../../../../lib/class/GenericGetStructureOrder.js'
clone       = require 'clone'
mocks       = require '../../_mocks.js'
rmErrors    = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

dbStructure         = null
errorObj            = null
getStructureOptions = null
getStructureOrder   = null
mocksUtils          = null
stub                = null
stub2               = null
val                 = null

describe 'Generic GET : GenericGetStructureOptions', ->

    beforeEach (done) ->
        getStructureOptions = null
        mocksUtils          = clone mocks
        done()

    it 'should create main structure', ->
        getStructureOptions = new GenericGetStructureOptions()
        getStructureOptions.should.be.instanceof GenericGetStructureOptions


    describe 'setOrder', ->

        beforeEach (done) ->
            dbStructure         = new DatabaseStructure()
            getStructureOptions = new GenericGetStructureOptions()
            getStructureOrder   = new GenericGetStructureOrder()
            stub                = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without params
        ###
        it 'should return ParameterError', ->
            getStructureOptions.setOrder()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with only returnType param
        ###
        it 'should return ParameterError', ->
            getStructureOptions.setOrder('foo')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with missing dbStructure param
        ###
        it 'should return ParameterError', ->
            getStructureOptions.setOrder('foo', [])
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###
        # Check with bad array content
        ###
        it 'should return ParameterError', ->
            getStructureOptions.setOrder('foo', ['foo'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        ###
        # Check with bad order.field content
        ###
        it 'should return ParameterError', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureOptions.setOrder('foo', [getStructureOrder], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        ###
        # Check with good order.field content
        ###
        it 'should return true', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            getStructureOptions.setOrder('foo', [getStructureOrder], dbStructure)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'addOrder', ->

        beforeEach (done) ->
            dbStructure         = new DatabaseStructure()
            getStructureOptions = new GenericGetStructureOptions()
            getStructureOrder   = new GenericGetStructureOrder()
            stub                = null
            stub2               = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without params
        ###
        it 'should return ParameterError', ->
            getStructureOptions.addOrder()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with only returnType param
        ###
        it 'should return ParameterError', ->
            getStructureOptions.addOrder('foo')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with missing dbStructure param
        ###
        it 'should return ParameterError', ->
            getStructureOptions.addOrder('foo', getStructureOrder)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###
        # Check with bad order.field content
        ###
        it 'should return false', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureOptions.addOrder('foo', getStructureOrder, dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###
        # Check with good order.field content
        ###
        it 'should return true', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            getStructureOptions.addOrder('foo', getStructureOrder, dbStructure)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###
        # Check with good existing order.field content
        ###
        it 'should return false', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            stub2 = sinon.stub(
                getStructureOptions,
                'containsOrder',
                ->
                    true
            )
            getStructureOptions.addOrder('foo', getStructureOrder, dbStructure)
                .then(
                    (result) ->
                        result.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'containsOrder', ->

        beforeEach (done) ->
            dbStructure         = new DatabaseStructure()
            getStructureOptions = new GenericGetStructureOptions()
            getStructureOrder   = new GenericGetStructureOrder()
            stub                = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without params
        ###
        it 'should return false', ->
            getStructureOptions.containsOrder().should.be.false

        ###
        # Check with good order.field content
        ###
        it 'should return true', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            getStructureOptions.addOrder('foo', getStructureOrder, dbStructure)
                .then(
                    (result) ->
                        result.should.be.true
                        getStructureOptions.addOrder('foo', getStructureOrder, dbStructure)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
                .then(
                    (result) ->
                        result.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'setLimit', ->

        beforeEach (done) ->
            getStructureOptions = new GenericGetStructureOptions()
            done()

        ###*
        # With a bad startIndex param
        ###
        it 'should return error', ->
            getStructureOptions.setLimit('a', 32)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # With a bad maximumRows param
        ###
        it 'should return error', ->
            getStructureOptions.setLimit(32, 'a')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # With good values
        ###
        it 'should return error', ->
            getStructureOptions.setLimit(32, 32)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
