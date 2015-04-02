'use strict'

###*
# @fileOverview Tests about QueryBuilder class
###

###*
# API custom classes
###
DatabaseStructure               = require '../../../../lib/class/DatabaseStructure.js'
Field                           = require '../../../../lib/class/Field.js'
GenericGetStructureConstraint   = require '../../../../lib/class/GenericGetStructureConstraint.js'
GenericGetStructureMain         = require '../../../../lib/class/GenericGetStructureMain.js'
QueryBuilder                    = require '../../../../lib/class/QueryBuilder.js'
Relation                        = require '../../../../lib/class/Relation.js'
Table                           = require '../../../../lib/class/Table.js'

###*
# Require modules
###
clone       = require 'clone'
mocks       = require '../../_mocks.js'
Q           = require 'q'
apiErrors   = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

###*
# Declare variables used in these tests
###
api             = undefined
builder         = undefined
connection      = undefined
constraint      = undefined
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
        val[0].should.be.instanceof apiErrors.ParameterError

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
        val[0].should.be.instanceof apiErrors.ParameterError

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
        val[0].should.be.instanceof apiErrors.ParameterError

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
        val[0].should.be.instanceof apiErrors.ParameterError

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
        val[0].should.be.instanceof apiErrors.ParameterError

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
        val[0].should.be.instanceof apiErrors.ParameterError

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

        ###*
        # Simulate an inverse relation
        ###
        it 'should be pushed to arrayFields', ->
            stub = sinon.stub(
                dbStructure,
                'containsInverseRelation',
                ->
                    true
            )
            queryBuilder.separateArrayValues(queryStructure)
            queryStructure.arrayFields.indexOf('foo').should.be.above -1

        ###*
        # Simulate a direct relation
        ###
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
                        error.should.be.instanceof apiErrors.ParameterError
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
                        error.should.be.instanceof apiErrors.ParameterError
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
                        error[0].should.be.instanceof apiErrors.ParameterError
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
                        error[0].should.be.instanceof apiErrors.ParameterError
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
                        error[0].should.be.instanceof apiErrors.ParameterError
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
                        error[0].should.be.instanceof apiErrors.ParameterError
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

    describe 'processContraintField', ->

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
            val = null
            done()

        ###*
        # Check with an objectType field
        ###
        it 'should work with field of objectType', ->
            val = queryBuilder.processContraintField('bar', 'foo')
            val.tableName.should.be.eql 'foo'
            val.columnName.should.be.eql 'bar'

        ###*
        # Check with another table field
        ###
        it 'should work with field of another table', ->
            val = queryBuilder.processContraintField('bar.foo2', 'foo')
            val.tableName.should.be.eql 'bar'
            val.columnName.should.be.eql 'foo2'

    describe 'buildGenericGetWhereSection', ->

        beforeEach (done) ->
            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            field           = new Field mocksUtils.dbStructureField
            mockUtils       = clone mocks
            table           = new Table({name: 'foo'})
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
            val = null
            done()

        ###*
        # Check without params
        ###
        it 'should return error without param', ->
            queryBuilder.buildGetWhereSection()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check without constraints array
        ###
        it 'should return error without constraints', ->
            queryBuilder.buildGetWhereSection('foo')
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with bad object type
        ###
        it 'should return error with bad objectType', ->
            queryBuilder.buildGetWhereSection(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with bad constraints param
        ###
        it 'should return error with bad constraints', ->
            queryBuilder.buildGetWhereSection('foo', null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with empty constraints array
        ###
        it 'should return empty array with empty constraints', ->
            queryBuilder.buildGetWhereSection('foo', [])
                .then(
                    (result) ->
                        result.should.be.eql ''
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )


        ###*
        # Check with constraints array content
        ###
        it 'should return error with bad constraints content', ->
            queryBuilder.buildGetWhereSection('foo', [null])
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with a valid constraints array
        ###
        it 'should return sql where', ->
            constraint = new GenericGetStructureConstraint(
                'foo',
                mocksUtils.GenericGetStructureConstraint,
                dbStructure
            )
            queryBuilder.buildGetWhereSection('foo', [constraint])
                .then(
                    (result) ->
                        result.should.be.eql ' `foo`.`foo` = = \'bar\''
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with a valid constraints array
        ###
        it 'should return sql where', ->
            mocksUtils.GenericGetStructureConstraint.link       = 'and'
            mocksUtils.GenericGetStructureConstraint.operator   = 'in'
            mocksUtils.GenericGetStructureConstraint.value      = ['foo','bar']
            constraint = new GenericGetStructureConstraint(
                'foo',
                mocksUtils.GenericGetStructureConstraint,
                dbStructure
            )
            queryBuilder.buildGetWhereSection('foo', [constraint])
                .then(
                    (result) ->
                        result.should.be.eql ' and  `foo`.`foo` in (\'foo\',\'bar\')'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'buildMainObjectIdsQuery', ->

        beforeEach (done) ->
            mocksUtils.dbStructureField.columnKey = 'pri'
            api             = mocksUtils.api
            connection      = mocksUtils.connection
            dbStructure     = new DatabaseStructure()
            field           = new Field mocksUtils.dbStructureField
            mockUtils       = clone mocks
            table           = new Table({name: 'foo'})
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
            stub = null
            val = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check with a bad param
        ###
        it 'should return error', ->
            queryBuilder.buildMainObjectIdsQuery(null)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                        error[0].should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with an error return during processing
        ###
        it 'should return error', ->
            stub = sinon.stub(
                queryBuilder,
                'buildGetFromSection'
                ->
                    Q.fcall ->
                        throw new Error 'unit-test'
            )
            queryBuilder.buildMainObjectIdsQuery(mocksUtils.queriesStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Error
                )

        ###*
        # Check with a fake foreign key
        ###
        it 'should return query', ->
            stub = sinon.stub(
                queryBuilder,
                'buildGetFromSection'
                ->
                    Q.fcall ->
                        return 'INNER JOIN bar'
            )
            queryBuilder.buildMainObjectIdsQuery(mocksUtils.queriesStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'SELECT bar FROM foo INNER JOIN bar;'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with a fake constraint
        ###
        it 'should return query', ->
            stub = sinon.stub(
                queryBuilder,
                'buildGetWhereSection'
                ->
                    Q.fcall ->
                        return 'foo = \'bar\''
            )
            queryBuilder.buildMainObjectIdsQuery(mocksUtils.queriesStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'SELECT bar FROM foo WHERE foo = \'bar\';'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
