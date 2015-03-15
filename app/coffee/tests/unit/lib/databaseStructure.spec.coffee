'use strict'

###*
# @fileOverview Tests about databaseStructure exports
###

# require packages
clone = require 'clone'
dbStructUtils = require '../../../lib/databaseStructure.js'
mocks = require '../_mocks.js'
rmErrors = require '../../../lib/errors.js'
sinon = require 'sinon'
should = require 'should'
sqlUtils = require '../../../lib/sql.js'

mocksUtils = null
cb = null
spy = null
stub = null
stub2 = null
val = null

describe 'Database structure classes and functions', ->

    it 'should exports all database structure classes', ->
        dbStructUtils.should.have.keys [
            'Table'
            'ComplexField'
            'SimpleField'
            'getTableNamesFromDB'
            'getForeignKeysFromDB'
            'getViewsFromDB'
            'getStructureFromDB'
            'getIndexesFromDB'
            'getInformationsFromDB'
        ]

    describe 'getTableNamesFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            stub2 = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getTableNamesFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                        results.should.be.true
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getTableNamesFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                        results.should.be.true
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2 = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getTableNamesFromDB mocksUtils.api
                .then(
                    (results) ->
                        stub.restore()
                        stub2.restore()
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getForeignKeysFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            stub2 = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getForeignKeysFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getForeignKeysFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2 = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getForeignKeysFromDB mocksUtils.api
                .then(
                    (results) ->
                        stub.restore()
                        stub2.restore()
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getViewsFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            stub2 = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getViewsFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getViewsFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2 = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getViewsFromDB mocksUtils.api
                .then(
                    (results) ->
                        stub.restore()
                        stub2.restore()
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getStructureFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            stub2 = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2 = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        stub.restore()
                        stub2.restore()
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getIndexesFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            stub2 = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getIndexesFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getIndexesFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2 = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getIndexesFromDB mocksUtils.api
                .then(
                    (results) ->
                        stub.restore()
                        stub2.restore()
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getInformationsFromDB', ->

        beforeEach (done) ->
            cb = sinon.spy()
            mocksUtils = clone mocks
            val = null
            spy = null
            stub = null
            done()

        it 'should reject an error if connection is not mocked properly', ->
            dbStructUtils.getInformationsFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.rejectDatabaseError
            dbStructUtils.getInformationsFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        stub.restore()
                        error.should.be.instanceof rmErrors.DatabaseError
                )
