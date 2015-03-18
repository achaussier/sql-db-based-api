'use strict'

###*
# @fileOverview Tests about databaseStructure exports
###

# require packages
clone               = require 'clone'
dbStructUtils       = require '../../../lib/databaseStructure.js'
DatabaseStructure   = require '../../../lib/databaseStructure/DatabaseStructure.js'
mocks       = require '../_mocks.js'
rmErrors    = require '../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'
sqlUtils    = require '../../../lib/sql.js'

mocksUtils  = clone mocks
cb      = null
spy     = null
stub    = null
stub2   = null
val     = null
val2    = null

describe 'Database structure classes and functions', ->

    it 'should exports all database structure classes', ->
        dbStructUtils.should.have.keys [
            'getStructureFromDB'
            'processDatabaseStructureParts'
            'manageTableCreation'
            'addFieldToTable'
            'managePartUniqueIndex'
            'manageRelations'
            'validatePartMandatoryValues'
            'validatePartKeys'
        ]

    describe 'getStructureFromDB', ->

        beforeEach (done) ->
            cb          = sinon.spy()
            mocksUtils  = clone mocks
            val         = null
            val2        = null
            spy         = null
            done()

        afterEach (done) ->
            stub.restore()  if stub?
            stub2.restore() if stub2?
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
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should resolve if all is ok', ->
            stub    = sinon.stub sqlUtils, 'executeSelect', mocksUtils.fakeDbStructureResultsFromDB
            stub2   = sinon.stub sqlUtils, 'getReadOnlyConnection', mocksUtils.fakeSqlConnection
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'validatePartMandatoryValues', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            val2        = null
            done()

        it 'should reject if no param', ->
            dbStructUtils.validatePartMandatoryValues()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->
                it 'should reject if bad obj param', ->
                    dbStructUtils.validatePartMandatoryValues badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should reject if some keys not exists', ->
            obj = mocksUtils.dbStructureField
            delete obj.tableName

            dbStructUtils.validatePartMandatoryValues obj
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        it 'should reject if some keys have null value', ->
            obj             = mocksUtils.dbStructureField
            obj.tableName   = null

            dbStructUtils.validatePartMandatoryValues obj
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        it 'should resolve if all keys have not null value', ->
            obj             = mocksUtils.dbStructureField
            obj.columnType  = 'foo'
            obj.isNullable  = 'foo'

            dbStructUtils.validatePartMandatoryValues obj
                .then(
                    (result) ->
                        result.should.have.property 'tableName'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'validatePartKeys', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            val2        = null
            done()

        it 'should reject if no param', ->
            dbStructUtils.validatePartKeys()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->
                it 'should reject if bad obj param', ->
                    dbStructUtils.validatePartKeys badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should reject if some keys not exists', ->
            obj = mocksUtils.dbStructureField
            delete obj.tableName

            dbStructUtils.validatePartKeys obj
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'bad-keys-for-object'
                )

        it 'should resolve if all keys have not null value', ->
            obj = mocksUtils.dbStructureField

            dbStructUtils.validatePartKeys obj
                .then(
                    (result) ->
                        result.should.have.property 'tableName'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'manageTableCreation', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            val2        = null
            done()

        it 'should be create a table if not exists', ->
            val = new DatabaseStructure()
            obj = mocksUtils.dbStructureField

            dbStructUtils.manageTableCreation(val, obj)
                .then(
                    (result) ->
                        result.should.have.property 'name'
                        result.name.should.be.eql 'foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )
