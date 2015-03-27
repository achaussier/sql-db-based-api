'use strict'

###*
# @fileOverview Tests about QueryBuilder class
###

# require packages
DatabaseStructure       = require '../../../../lib/class/DatabaseStructure.js'
Field                   = require '../../../../lib/class/Field.js'
GenericGetStructureMain = require '../../../../lib/class/GenericGetStructureMain.js'
QueryBuilder            = require '../../../../lib/class/QueryBuilder.js'
Relation                = require '../../../../lib/class/Relation.js'
Table                   = require '../../../../lib/class/Table.js'

clone       = require 'clone'
mocks       = require '../../_mocks.js'
rmErrors    = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

api             = undefined
builder         = undefined
connection      = undefined
dbStructure     = undefined
errorObj        = undefined
getStructure    = undefined
mocksUtils      = undefined
queryBuilder    = undefined
queryStructure  = undefined
stub            = undefined
stub2           = undefined
table           = undefined
val             = undefined

describe 'QueryBuilder class', ->

    beforeEach (done) ->
        builder     = null
        errorObj    = null
        mocksUtils  = clone mocks
        val         = null

        api             = mocksUtils.api
        connection      = mocksUtils.connection
        dbStructure     = new DatabaseStructure()
        table           = new Table({name: 'foo'})
        dbStructure.addTable table
        getStructure    = new GenericGetStructureMain('foo', dbStructure)
        done()

    ###*
    # Check without params
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder()
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad api param
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder(
            null,
            connection,
            getStructure,
            false,
            dbStructure
        )
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad connection param
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder(
            api,
            null,
            getStructure,
            false,
            dbStructure
        )
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad getStructure param
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder(
            api,
            connection,
            null,
            false,
            dbStructure
        )
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad doTotalCount param
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder(
            api,
            connection,
            getStructure,
            null,
            dbStructure
        )
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad dbStructure param
    ###
    it 'should return error if bad param', ->
        val = new QueryBuilder(
            api,
            connection,
            getStructure,
            false,
            null
        )
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check good dbStructure param
    ###
    it 'should return a new instance', ->
        val = new QueryBuilder(
            api,
            connection,
            getStructure,
            false,
            dbStructure
        )
        val.should.be.instanceof QueryBuilder

    ###*
    # Check method to generate structure to store requests and data between promises
    ###
    describe 'generateQueriesStructure', ->

        beforeEach (done) ->
            val = null
            done()

        ###*
        # All is Ak
        ###
        it 'should return a new structure', ->
            val = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            val.generateQueriesStructure()
                .then(
                    (structure) ->
                        structure.should.have.keys [
                            'simpleFields'
                            'arrayFields'
                            'getIdsQuery'
                            'getMainObjectQuery'
                            'getArrayValuesQueries'
                        ]
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'separateArrayValues', ->

        beforeEach (done) ->
            mocksUtils      = clone mocks
            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            table           = new Table({name: 'foo'})
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            stub            = null
            queryStructure  = mocksUtils.queriesStructure
            queryBuilder.getStructure.select = ['foo']
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        it 'should be pushed to arrayFields', ->
            stub = sinon.stub(
                dbStructure,
                'containsInverseRelation',
                ->
                    true
            )
            queryBuilder.separateArrayValues(queryStructure)
            queryStructure.arrayFields.indexOf('foo').should.be.above -1

        it 'should be pushed to simpleFields', ->
            stub = sinon.stub(
                dbStructure,
                'containsInverseRelation',
                ->
                    false
            )
            queryBuilder.separateArrayValues(queryStructure)
            queryStructure.simpleFields.indexOf('foo').should.be.above  -1

    describe 'sortSelectByDepth', ->

        beforeEach (done) ->
            badObj          = null
            mocksUtils      = clone mocks
            val             = undefined
            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            table           = new Table({name: 'foo'})
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            queryBuilder.sortSelectByDepth()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check without a string array
        ###
        it 'should reject if bad param', ->
            queryBuilder.sortSelectByDepth([null])
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with a good param
        ###
        it 'should resolve and order by depth', ->
            queryBuilder.sortSelectByDepth(['a', 'a.b.c', 'a.b'])
                .then(
                    (result) ->
                        result[0].should.be.eql 'a.b.c'
                        result[1].should.be.eql 'a.b'
                        result[2].should.be.eql 'a'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'isListOfValue', ->

        beforeEach (done) ->

            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            table           = new Table({name: 'foo'})
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            done()

        ###*
        # Check without param
        ###
        it 'should return false', ->
            queryBuilder.isListOfValue().should.be.false

        ###*
        # Check with a 'in' param
        ###
        it 'should return true', ->
            queryBuilder.isListOfValue('in').should.be.true

        ###*
        # Check with a 'not in' param
        ###
        it 'should return true', ->
            queryBuilder.isListOfValue('not in').should.be.true

        ###*
        # Check with a '=' param
        ###
        it 'should return false', ->
            queryBuilder.isListOfValue('=').should.be.false

    describe 'buildGetFromSection', ->

        beforeEach (done) ->
            badObj          = null
            field           = undefined
            mocksUtils      = clone mocks
            stub            = null
            stub2           = null
            table           = null
            val             = undefined
            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            done()

        afterEach (done) ->
            stub.restore()  if stub?.restore?
            stub2.restore() if stub2?.restore?
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            queryBuilder.buildGetFromSection()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof rmErrors.ParameterError
                )


        ###*
        # Check with a bad objectType param
        ###
        it 'should reject if bad param', ->
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            queryBuilder.buildGetFromSection(null, ['foo'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with a bad ordered param
        ###
        it 'should reject if bad param', ->
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            queryBuilder.buildGetFromSection('foo', null, dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with a bad dbStructure param
        ###
        it 'should reject if bad param', ->
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            queryBuilder.buildGetFromSection('foo', ['foo'], null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof rmErrors.ParameterError
                )

        ###*
        # Check with a good fk param
        ###
        it 'should resolve if good fk param', ->
            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            stub    = sinon.stub(
                Table.prototype,
                'isForeignKey'
                ->
                    true
            )
            stub2   = sinon.stub(
                Field.prototype,
                'isRequired'
                ->
                    true
            )

            queryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error[0].data.should.be.eql 'buildInnerJoin should be extended by a sub class'
                )

        ###*
        # Check with a good inverse relation param
        ###
        it 'should resolve if good fk param', ->
            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            mocksUtils.dbStructureRelation.isInverse    = true
            field       = new Field mocksUtils.dbStructureField
            table       = new Table mocksUtils.dbStructureTable
            relation    = new Relation mocksUtils.dbStructureRelation
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            stub    = sinon.stub(
                Table.prototype,
                'isForeignKey'
                ->
                    false
            )
            stub2   = sinon.stub(
                Table.prototype,
                'isRelationExists'
                ->
                    true
            )

            queryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error[0].data.should.be.eql 'buildLeftOuterJoin should be extended by a sub class'
                )

        ###*
        # Check reject if no relation param
        ###
        it 'should reject if no relation param', ->
            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
            getStructure    = new GenericGetStructureMain('foo', dbStructure)
            queryBuilder    = new QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            stub    = sinon.stub(
                Table.prototype,
                'isForeignKey'
                ->
                    false
            )
            stub2   = sinon.stub(
                Field.prototype,
                'isRequired'
                ->
                    true
            )

            queryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                )
