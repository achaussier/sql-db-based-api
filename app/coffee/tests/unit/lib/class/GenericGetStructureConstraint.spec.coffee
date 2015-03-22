'use strict'

###*
# @fileOverview Test file for GenericGetStructureConstraint class
###

# require packages
DatabaseStructure               = require '../../../../lib/class/DatabaseStructure.js'
GenericGetStructureConstraint   = require '../../../../lib/class/GenericGetStructureConstraint.js'
GenericGetStructureMain         = require '../../../../lib/class/GenericGetStructureMain.js'
clone       = require 'clone'
mocks       = require '../../_mocks.js'
rmErrors    = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

dbStructure             = null
errorObj                = null
getStructureMain        = null
getStructureConstraint  = null
mocksUtils              = null
stub                    = null
table                   = null
val                     = null

describe 'Generic GET : GenericGetStructureConstraint', ->

    beforeEach (done) ->
        errorObj                = null
        getStructureConstraint  = null
        getStructureMain        = null
        mocksUtils              = clone mocks
        stub                    = null
        table                   = null
        val                     = null

        ###*
        # Create prerequisite for constructor
        ###
        dbStructure = new DatabaseStructure()

        done()

    afterEach (done) ->
        stub.restore() if stub?.restore?
        done()

    ###*
    # Test without link
    ###
    it 'should return a new instance', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        getStructureConstraint = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        getStructureConstraint.should.be.instanceof GenericGetStructureConstraint

    ###*
    # Test with a link
    ###
    it 'should return a new instance', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.link = 'and'

        getStructureConstraint = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        getStructureConstraint.should.be.instanceof GenericGetStructureConstraint

    ###*
    # Test with a number value
    ###
    it 'should return a new instance', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.value = 5

        getStructureConstraint = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        getStructureConstraint.should.be.instanceof GenericGetStructureConstraint

    ###*
    # Test with a bad operator for number value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'foo'
        mocksUtils.GenericGetStructureConstraint.value      = 5

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad type for number value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.type   = 'foo'
        mocksUtils.GenericGetStructureConstraint.value  = 5

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with an array value
    ###
    it 'should return a new instance', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'in'
        mocksUtils.GenericGetStructureConstraint.value      = [ 'foo' ]

        getStructureConstraint = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        getStructureConstraint.should.be.instanceof GenericGetStructureConstraint

    ###*
    # Test with an empty array value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'in'
        mocksUtils.GenericGetStructureConstraint.value      = []

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad array value with between operator
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'between'
        mocksUtils.GenericGetStructureConstraint.value      = ['foo']

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad operator for array value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'foo'
        mocksUtils.GenericGetStructureConstraint.value      = [ 'foo' ]

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad type for array value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'in'
        mocksUtils.GenericGetStructureConstraint.type       = 'foo'
        mocksUtils.GenericGetStructureConstraint.value      = [ 'foo' ]

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad type for string value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.type       = 'foo'

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Test with a bad operator for string value
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        mocksUtils.GenericGetStructureConstraint.operator   = 'foo'

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with a bad constraintData
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        val = new GenericGetStructureConstraint(
            'foo',
            {},
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with a null constraintData
    ###
    it 'should return an error array', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )

        val = new GenericGetStructureConstraint(
            'foo',
            null,
            dbStructure
        )

        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with a bad link
    ###
    it 'should return an error', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        mocksUtils.GenericGetStructureConstraint.link = 'foo'

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            null
        )

        val.should.be.instanceof rmErrors.ParameterError

    ###*
    # Check with a bad link
    ###
    it 'should return an error', ->
        stub = sinon.stub(
            dbStructure,
            'checkPath',
            ->
                true
        )
        mocksUtils.GenericGetStructureConstraint.link = 'foo'

        val = new GenericGetStructureConstraint(
            'foo',
            mocksUtils.GenericGetStructureConstraint,
            null
        )

        val.should.be.instanceof rmErrors.ParameterError


