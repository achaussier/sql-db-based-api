'use strict'

###*
# @fileOverview Tests about databaseStructure exports
###

# require packages
clone               = require 'clone'
dbStructUtils       = require '../../../lib/databaseStructure.js'
DatabaseStructure   = require '../../../lib/databaseStructure/DatabaseStructure.js'
Field       = require '../../../lib/databaseStructure/Field.js'
mocks       = require '../_mocks.js'
Q           = require 'q'
rmErrors    = require '../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'
sqlUtils    = require '../../../lib/sql.js'
Table       = require '../../../lib/databaseStructure/Table.js'

mocksUtils  = clone mocks
cb          = null
dbStructure = null
parts       = null
spy         = null
stub        = null
stub2       = null
table1      = null
table2      = null
val         = null
val2        = null

describe 'Database structure classes and functions', ->

    it 'should exports all database structure classes', ->
        dbStructUtils.should.have.keys [
            'checkPartKeys'
            'checkPartMandatoryValues'
            'getStructureFromDB'
            'processDatabaseStructureParts'
            'setField'
            'setTable'
            'setUniqueIndex'
            'setRelations'
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

    describe 'checkPartMandatoryValues', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            val2        = null
            done()

        it 'should reject if no param', ->
            dbStructUtils.checkPartMandatoryValues()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->
                it 'should reject if bad obj param', ->
                    dbStructUtils.checkPartMandatoryValues badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should reject if some keys not exists', ->
            obj = mocksUtils.dbStructureField
            delete obj.tableName

            dbStructUtils.checkPartMandatoryValues obj
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

            dbStructUtils.checkPartMandatoryValues obj
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

            dbStructUtils.checkPartMandatoryValues obj
                .then(
                    (result) ->
                        result.should.have.property 'tableName'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'checkPartKeys', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            val2        = null
            done()

        it 'should reject if no param', ->
            dbStructUtils.checkPartKeys()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->
                it 'should reject if bad obj param', ->
                    dbStructUtils.checkPartKeys badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should reject if some keys not exists', ->
            obj = mocksUtils.dbStructureField
            delete obj.tableName

            dbStructUtils.checkPartKeys obj
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'bad-keys-for-object'
                )

        it 'should resolve if all keys have not null value', ->
            obj = mocksUtils.dbStructureField

            dbStructUtils.checkPartKeys obj
                .then(
                    (result) ->
                        result.should.have.property 'tableName'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'setTable', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            val         = null
            val2        = null
            stub        = null
            done()

        afterEach (done) ->
            stub.restore() if stub? and stub.restore?
            done()

        it 'should be create a table if not exists', ->
            val = new DatabaseStructure()
            obj = mocksUtils.dbStructureField

            dbStructUtils.setTable(val, obj)
                .then(
                    (result) ->
                        result.should.have.property 'name'
                        result.name.should.be.eql 'foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should be reject if table not exists after Get', ->
            val  = new DatabaseStructure()
            obj  = mocksUtils.dbStructureField
            stub = sinon.stub(
                val,
                'getTable',
                ->
                    null
            )

            dbStructUtils.setTable(val, obj)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ServerError
                    )

        it 'should add a new field to a table', ->
            val = new Table mocksUtils.dbStructureTable

            dbStructUtils.setField val, mocksUtils.dbStructureField
                .then(
                    (result) ->
                        result.fields.length.should.be.eql 1
                    (error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'setUniqueIndex', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            val         = undefined
            spy         = null
            stub        = null
            done()

        afterEach (done) ->
            stub.restore() if stub? and stub.restore?
            spy.restore() if spy? and spy.restore?
            done()

        it 'should not call addUniqueIndexPart if no index data', ->
            val = new Table mocksUtils.dbStructureTable
            spy = sinon.spy val, 'addUniqueIndexPart'

            dbStructUtils.setUniqueIndex val, {}
                .then(
                    (result) ->
                        spy.called.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should add part if index data', ->
            val = new Table mocksUtils.dbStructureTable
            obj =
                uniqueIndexName: 'foo'
                tableName      : 'foo'
                columnName     : 'bar'
            spy = sinon.spy val, 'addUniqueIndexPart'

            dbStructUtils.setUniqueIndex val, obj
                .then(
                    (result) ->
                        spy.called.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

    describe 'setRelations', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            dbStructure = null
            table1      = null
            table2      = null
            spy         = null
            spy2        = null
            done()

        afterEach (done) ->
            spy.restore()  if spy?  and spy.restore?
            spy2.restore() if spy2? and spy2.restore?
            done()

        it 'should not call addRelation', ->
            dbStructure = new DatabaseStructure()
            table1      = new Table mocksUtils.dbStructureTable
            spy         = sinon.spy table1, 'addRelation'

            dbStructUtils.setRelations dbStructure, table1, {}
                .then(
                    (result) ->
                        spy.called.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should add relation', ->
            dbStructure = new DatabaseStructure()
            table1      = new Table { name: 'foo'  }
            table2      = new Table { name: 'foo2' }

            dbStructure.addTable table1
            dbStructure.addTable table2

            spy  = sinon.spy table1, 'addRelation'
            spy2 = sinon.spy table2, 'addRelation'

            obj  =
                tableName    : 'foo'
                columnName   : 'bar'
                refTableName : 'foo2'
                refColumnName: 'bar2'


            dbStructUtils.setRelations dbStructure, table1, obj
                .then(
                    (result) ->
                        spy.called.should.be.true
                        spy2.called.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should add relation and create ref table if not exists', ->
            dbStructure = new DatabaseStructure()
            table1      = new Table { name: 'foo'  }

            dbStructure.addTable table1

            spy = sinon.spy table1, 'addRelation'
            obj =
                tableName    : 'foo'
                columnName   : 'bar'
                refTableName : 'foo2'
                refColumnName: 'bar2'


            dbStructUtils.setRelations dbStructure, table1, obj
                .then(
                    (result) ->
                        spy.called.should.be.true
                        dbStructure.tables.length.should.be.eql 2
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

    describe 'processDatabaseStructureParts', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            parts       = null
            spy         = null
            spy2        = null
            done()

        afterEach (done) ->
            spy.restore()  if spy?  and spy.restore?
            spy2.restore() if spy2? and spy2.restore?
            done()

        it 'should executed without data returned', ->
            dbStructUtils.processDatabaseStructureParts []
                .then(
                    (result) ->
                        result.should.be.instanceof DatabaseStructure
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should executed with one part', ->
            parts = [
                mocksUtils.dbStructureField
            ]
            dbStructUtils.processDatabaseStructureParts parts
                .then(
                    (result) ->
                        result.should.be.instanceof DatabaseStructure
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        it 'should reject if error occurs', ->
            mocksUtils.dbStructureField.isNullable = null
            parts = [
                mocksUtils.dbStructureField
            ]
            dbStructUtils.processDatabaseStructureParts parts
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                    )
