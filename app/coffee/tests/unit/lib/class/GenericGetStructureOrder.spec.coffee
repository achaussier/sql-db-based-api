'use strict'

###*
# @fileOverview Test file for GenericGetStructureOrder class
###

# require packages
DatabaseStructure           = require '../../../../lib/class/DatabaseStructure.js'
GenericGetStructureOrder    = require '../../../../lib/class/GenericGetStructureOrder.js'
clone       = require 'clone'
mocks       = require '../../_mocks.js'
rmErrors    = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

dbStructure         = null
getStructureOrder   = null
stub                = null

describe 'Generic GET : GenericGetStructureOrder', ->
    beforeEach (done) ->
        dbStructure         = new DatabaseStructure()
        getStructureOrder   = null
        stub                = null
        done()

    afterEach (done) ->
        stub.restore() if stub?.restore?
        done()

    ###*
    # Check without params
    ###
    it 'should return ParameterError', ->
        getStructureOrder = new GenericGetStructureOrder()
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with only returnType param
    ###
    it 'should return ParameterError', ->
        getStructureOrder = new GenericGetStructureOrder('foo')
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with missing asc param
    ###
    it 'should return ParameterError', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar')
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with missing dbStructure param
    ###
    it 'should return ParameterError', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar', 'asc')
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

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
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar', 'asc', dbStructure)
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

    ###
    # Check with bad asc content
    ###
    it 'should return false', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar', 'assc', dbStructure)
        getStructureOrder[0].should.be.instanceof rmErrors.ParameterError

    ###
    # Check with good order.field content asc
    ###
    it 'should return true', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar', 'asc', dbStructure)
        getStructureOrder.should.be.instanceof GenericGetStructureOrder

    ###
    # Check with good order.field content desc
    ###
    it 'should return true', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        getStructureOrder = new GenericGetStructureOrder('foo', 'bar', 'desc', dbStructure)
        getStructureOrder.should.be.instanceof GenericGetStructureOrder
