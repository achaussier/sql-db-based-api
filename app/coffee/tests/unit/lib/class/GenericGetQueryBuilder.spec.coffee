'use strict'

###*
# @fileOverview Tests about GenericGetQueryBuilder class
###

# require packages
DatabaseStructure       = require '../../../../lib/class/DatabaseStructure.js'
GenericGetQueryBuilder  = require '../../../../lib/class/GenericGetQueryBuilder.js'
GenericGetStructureMain = require '../../../../lib/class/GenericGetStructureMain.js'
Table                   = require '../../../../lib/class/Table.js'
clone       = require 'clone'
Field       = require '../../../../lib/class/Field.js'
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
table           = undefined
val             = undefined

describe 'Generic get : GenericGetQueryBuilder class', ->

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
        val = new GenericGetQueryBuilder()
        val.should.be.instanceof Array
        val[0].should.be.instanceof rmErrors.ParameterError

    ###*
    # Check bad api param
    ###
    it 'should return error if bad param', ->
        val = new GenericGetQueryBuilder(
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
        val = new GenericGetQueryBuilder(
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
        val = new GenericGetQueryBuilder(
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
        val = new GenericGetQueryBuilder(
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
        val = new GenericGetQueryBuilder(
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
        val = new GenericGetQueryBuilder(
            api,
            connection,
            getStructure,
            false,
            dbStructure
        )
        val.should.be.instanceof GenericGetQueryBuilder

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
            val = new GenericGetQueryBuilder(
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
            queryBuilder    = new GenericGetQueryBuilder(
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
