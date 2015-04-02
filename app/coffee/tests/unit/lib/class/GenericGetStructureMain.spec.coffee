'use strict'

###*
# @fileOverview Test file for GenericGetStructureMain class
###

###*
# Required custom classes
###
DatabaseStructure               = require '../../../../lib/class/DatabaseStructure.js'
Field                           = require '../../../../lib/class/Field.js'
GenericGetStructureConstraint   = require '../../../../lib/class/GenericGetStructureConstraint.js'
GenericGetStructureMain         = require '../../../../lib/class/GenericGetStructureMain.js'
GenericGetStructureOptions      = require '../../../../lib/class/GenericGetStructureOptions.js'
Table                           = require '../../../../lib/class/Table.js'

###*
# Required modules
###
clone       = require 'clone'
mocks       = require '../../_mocks.js'
apiErrors   = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

###*
# Declare variables
###
dbStructure         = undefined
errorObj            = undefined
field               = undefined
getStructureMain    = undefined
mockField1          = undefined
mockField2          = undefined
mocksUtils          = undefined
relation            = undefined
stub                = undefined
table               = undefined

describe 'Generic GET : GenericGetStructureMain', ->

    beforeEach (done) ->
        dbStructure         = new DatabaseStructure()
        getStructureMain    = null
        mocksUtils          = clone mocks
        dbStructure.addTable mocksUtils.dbStructureTable
        done()

    ###*
    # Check with existing table
    ###
    it 'should create main structure', ->

        getStructureMain = new GenericGetStructureMain 'foo', dbStructure
        getStructureMain.should.be.instanceof GenericGetStructureMain
        getStructureMain.should.have.keys [
            'constraints'
            'options'
            'returnType'
            'select'
        ]

    ###*
    # Check with bad objectType param
    ###
    it 'should not create main structure', ->
        getStructureMain = new GenericGetStructureMain null, dbStructure
        getStructureMain.should.be.instanceof Array

    ###*
    # Check with bad databaseStructure param
    ###
    it 'should not create main structure', ->
        getStructureMain = new GenericGetStructureMain 'foo', null
        getStructureMain.should.be.instanceof Array

    ###*
    # Check with bad a not managed table
    ###
    it 'should not create main structure', ->
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

        ###*
        # With good select values
        ###
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

        ###*
        # With bad path in select
        ###
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
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # With null select param
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # With null database structure param
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
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

        ###*
        # With good value
        ###
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

        ###*
        # With bah path
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # With null value
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # With null database structure
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
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

        ###*
        # With good GenericGetStructureOptions object
        ###
        it 'should set structure options', ->
            getStructureOptions = new GenericGetStructureOptions('foo')
            getStructureMain.setOptions(getStructureOptions)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # With bad GenericGetStructureOptions object
        ###
        it 'should not set bad structure options', ->
            getStructureMain.setOptions(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
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

        ###*
        # With valid constraints value
        ###
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

        ###*
        # With invalid constraints value : null
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
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

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # With valid constraints value
        ###
        it 'should add structure constraint', ->
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
            getStructureMain.addConstraint(getStructureConstraint)
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # With invalid constraint value
        ###
        it 'should not set bad structure options', ->
            getStructureMain.addConstraint(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
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

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # With valid constraints array
        ###
        it 'should return true', ->
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
            getStructureMain.isConstraintArray([getStructureConstraint]).should.be.true

        ###*
        # With null param
        ###
        it 'should be false', ->
            getStructureMain.isConstraintArray(null).should.be.false

        ###*
        # With a string param
        ###
        it 'should be false', ->
            getStructureOptions = new GenericGetStructureOptions('foo')
            getStructureMain.isConstraintArray(getStructureOptions).should.be.false

        ###*
        # With values in array
        ###
        it 'should be false', ->
            getStructureMain.isConstraintArray([null]).should.be.false
