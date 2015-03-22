'use strict'

###*
# @fileOverview Test file for GenericGetStructureMain class
###

# require packages
DatabaseStructure               = require '../../../../lib/class/DatabaseStructure.js'
GenericGetStructureConstraint   = require '../../../../lib/class/GenericGetStructureConstraint.js'
GenericGetStructureMain         = require '../../../../lib/class/GenericGetStructureMain.js'
GenericGetStructureOptions      = require '../../../../lib/class/GenericGetStructureOptions.js'
clone       = require 'clone'
Field       = require '../../../../lib/class/Field.js'
mocks       = require '../../_mocks.js'
rmErrors    = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'
Table       = require '../../../../lib/class/Table.js'

dbStructure         = null
errorObj            = null
field               = null
getStructureMain    = null
mockField1          = null
mockField2          = null
mocksUtils          = null
relation            = null
stub                = null
table               = null
val2                = null

describe 'Generic GET : GenericGetStructureMain', ->

    beforeEach (done) ->
        dbStructure         = null
        errorObj            = null
        field               = null
        getStructureMain    = null
        mockField1          = null
        mockField2          = null
        mocksUtils          = clone mocks
        relation            = null
        stub                = null
        table               = null
        val2                = null
        done()

    it 'should create main structure', ->
        ###*
        # Create prerequisite for constructor
        ###
        dbStructure = new DatabaseStructure()
        dbStructure.addTable mocksUtils.dbStructureTable

        getStructureMain = new GenericGetStructureMain 'foo', dbStructure
        getStructureMain.should.be.instanceof GenericGetStructureMain
        getStructureMain.should.have.keys [
            'constraints'
            'options'
            'returnType'
            'select'
        ]

    it 'should not create main structure', ->
        ###*
        # Create prerequisite for constructor
        ###
        dbStructure = new DatabaseStructure()
        dbStructure.addTable mocksUtils.dbStructureTable

        ###*
        # Bad objectType param
        ###
        getStructureMain = new GenericGetStructureMain null, dbStructure
        getStructureMain.should.be.instanceof Array

    it 'should not create main structure', ->
        ###*
        # Bad databaseStructure param
        ###
        getStructureMain = new GenericGetStructureMain 'foo', null
        getStructureMain.should.be.instanceof Array

    it 'should not create main structure', ->
        ###*
        # Create prerequisite for constructor
        ###
        dbStructure = new DatabaseStructure()
        dbStructure.addTable mocksUtils.dbStructureTable

        ###*
        # Table not exists
        ###
        getStructureMain = new GenericGetStructureMain 'bar', dbStructure
        getStructureMain.should.be.instanceof Array

    describe 'setSelect', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain = new GenericGetStructureMain 'foo', dbStructure
            stub             = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        it 'should set a new select array', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            getStructureMain.setSelect(['bar'], dbStructure)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should not set a new select array', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.setSelect(['foooo'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        it 'should not set a new select array', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.setSelect(null, dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should not set a new select array', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.setSelect(['foooo'], null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

    describe 'addSelect', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain = new GenericGetStructureMain 'foo', dbStructure
            stub             = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        it 'should add a new path', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )
            getStructureMain.addSelect('bar', dbStructure)
                .then(
                    (result) ->
                        result.should.be.true
                        getStructureMain.select.indexOf('bar').should.be.eql 0
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should not add a new path', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.addSelect('foooo', dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should not add a new path', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.addSelect(null, dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should not add a new path', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    false
            )
            getStructureMain.addSelect('foooo', null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

    describe 'setOptions', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain    = new GenericGetStructureMain 'foo', dbStructure
            getStructureOptions = null
            stub                = null
            done()


        it 'should set structure options', ->
            getStructureOptions = new GenericGetStructureOptions('foo')
            getStructureMain.setOptions(getStructureOptions)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should not set bad structure options', ->
            getStructureMain.setOptions(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

    describe 'setConstraints', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain    = new GenericGetStructureMain 'foo', dbStructure
            stub                = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()


        it 'should set structure constraints', ->
            stub = sinon.stub(
                getStructureMain,
                'isConstraintArray',
                ->
                    true
            )
            getStructureMain.setConstraints([])
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should not set bad structure constraints', ->
            stub = sinon.stub(
                getStructureMain,
                'isConstraintArray',
                ->
                    false
            )
            getStructureMain.setConstraints(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

    describe 'addConstraint', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain        = new GenericGetStructureMain 'foo', dbStructure
            getStructureConstraint  = null
            stub                    = null
            done()


        it 'should set structure options', ->
            getStructureConstraint = new GenericGetStructureConstraint('foo')
            getStructureMain.addConstraint(getStructureConstraint)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should not set bad structure options', ->
            getStructureMain.addConstraint(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

    describe 'isConstraintArray', ->
        beforeEach (done) ->
            ###*
            # Create prerequisite for constructor
            ###
            dbStructure = new DatabaseStructure()
            dbStructure.addTable(
                new Table { name: 'foo' }
            )
            dbStructure.addTable(
                new Table { name: 'foo2' }
            )

            ###*
            # Create main get structure
            ###
            getStructureMain        = new GenericGetStructureMain 'foo', dbStructure
            getStructureConstraint  = null
            stub                    = null
            done()


        it 'should return true', ->
            getStructureConstraint = new GenericGetStructureConstraint('foo')
            getStructureMain.isConstraintArray([getStructureConstraint]).should.be.true

        it 'should be false', ->
            getStructureMain.isConstraintArray(null).should.be.false

        it 'should be false', ->
            getStructureOptions = new GenericGetStructureOptions('foo')
            getStructureMain.isConstraintArray(getStructureOptions).should.be.false

        it 'should be false', ->
            getStructureMain.isConstraintArray([null]).should.be.false
