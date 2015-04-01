'use strict'

###*
# @fileOverview Tests about databaseStructure exports
###

###*
# Required modules
###
clone           = require 'clone'
dbStructUtils   = require '../../../lib/databaseStructure.js'
mocks           = require '../_mocks.js'
Q               = require 'q'
rmErrors        = require '../../../lib/errors.js'
sinon           = require 'sinon'
should          = require 'should'

###*
# Required custom classes
###
DatabaseStructure   = require '../../../lib/class/DatabaseStructure.js'
Field               = require '../../../lib/class/Field.js'
Table               = require '../../../lib/class/Table.js'

###*
# Declare variables
###
mocksUtils  = clone mocks
cb          = undefined
dbStructure = undefined
part        = undefined
parts       = undefined
spy         = undefined
stub        = undefined
stub2       = undefined
table1      = undefined
table2      = undefined

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
            mocksUtils  = clone mocks
            stub        = null
            stub2       = null
            done()

        afterEach (done) ->
            stub.restore()  if stub?
            stub2.restore() if stub2?
            done()

        ###*
        # With null api object
        ###
        it 'should reject an error if no database configured', ->
            dbStructUtils.getStructureFromDB null
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # With null api.database object
        ###
        it 'should reject an error if no database configured', ->
            dbStructUtils.getStructureFromDB { database: null }
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # With good database object
        ###
        it 'should resolve', ->
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        results.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Simulate an error on get connection
        ###
        it 'should reject an error if unabled to get a connection', ->
            stub = sinon.stub(
                mocksUtils.api.database,
                'getReadConnection',
                mocksUtils.rejectDatabaseError
            )
            dbStructUtils.getStructureFromDB mocksUtils.api
                .then(
                    (results) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        ###*
        # Check with all ok with fake connection object
        ###
        it 'should resolve if all is ok', ->
            stub    = sinon.stub(
                mocksUtils.api.database,
                'executeSelect',
                mocksUtils.fakeDbStructureResultsFromDB
            )
            stub2   = sinon.stub(
                mocksUtils.api.database,
                'getReadConnection',
                mocksUtils.fakeSqlConnection
            )

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
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            dbStructUtils.checkPartMandatoryValues()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with bad params
        ###
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

        ###*
        # Check with incomplete object
        ###
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

        ###*
        # Check with null object values
        ###
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

        ###*
        # Check with a good object
        ###
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
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            dbStructUtils.checkPartKeys()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with bad param
        ###
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

        ###*
        # Check with incomplete objet
        ###
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

        ###*
        # Check with null values
        ###
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
            dbStructure = new DatabaseStructure()
            mocksUtils  = clone mocks
            part        = null
            stub        = null
            table1      = new Table mocksUtils.dbStructureTable
            done()

        afterEach (done) ->
            stub.restore() if stub? and stub.restore?
            done()

        ###*
        # Check with an existing table
        ###
        it 'should not create a table if exists', ->
            part = mocksUtils.dbStructureField
            dbStructure.addTable table1

            dbStructUtils.setTable(dbStructure, part)
                .then(
                    (result) ->
                        result.should.have.property 'name'
                        result.name.should.be.eql 'foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        ###*
        # Check with a not existing table
        ###
        it 'should be create a table if not exists', ->
            part = mocksUtils.dbStructureField

            dbStructUtils.setTable(dbStructure, part)
                .then(
                    (result) ->
                        result.should.have.property 'name'
                        result.name.should.be.eql 'foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        ###*
        # Simulate a no table create
        ###
        it 'should be reject if table not exists after Get', ->
            part    = mocksUtils.dbStructureField
            stub    = sinon.stub(
                dbStructure,
                'getTable',
                ->
                    null
            )

            dbStructUtils.setTable(dbStructure, part)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ServerError
                    )

        ###*
        # Check add a new field
        ###
        it 'should add a new field to a table', ->
            dbStructUtils.setField table1, mocksUtils.dbStructureField
                .then(
                    (result) ->
                        result.fields.length.should.be.eql 1
                    (error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'setUniqueIndex', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            spy         = null
            table1      = new Table mocksUtils.dbStructureTable
            done()

        afterEach (done) ->
            spy.restore() if spy?.restore?
            done()

        ###*
        # Check without index data
        ###
        it 'should not call addUniqueIndexPart if no index data', ->
            spy = sinon.spy table1, 'addUniqueIndexPart'

            dbStructUtils.setUniqueIndex table1, {}
                .then(
                    (result) ->
                        spy.called.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        ###*
        # Check with index data
        ###
        it 'should add part if index data', ->
            obj =
                uniqueIndexName: 'foo'
                tableName      : 'foo'
                columnName     : 'bar'
            spy = sinon.spy table1, 'addUniqueIndexPart'

            dbStructUtils.setUniqueIndex table1, obj
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

        ###*
        # Check with a no relation data
        ###
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

        ###*
        # Check with relations between tables
        ###
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

        ###*
        # Check with a relation with a not existing table
        ###
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

        ###*
        # Check with empty database result
        ###
        it 'should executed without data returned', ->
            dbStructUtils.processDatabaseStructureParts []
                .then(
                    (result) ->
                        result.should.be.instanceof DatabaseStructure
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                    )

        ###*
        # Check with a no empty database result
        ###
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

        ###*
        # Check with a bad field
        ###
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
