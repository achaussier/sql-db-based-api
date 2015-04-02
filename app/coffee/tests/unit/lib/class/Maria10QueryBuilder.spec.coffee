'use strict'

###*
# @fileOverview Tests about Maria10QueryBuilder class
###

###*
# Required custom classes
###
DatabaseStructure       = require '../../../../lib/class/DatabaseStructure.js'
Field                   = require '../../../../lib/class/Field.js'
GenericGetStructureMain = require '../../../../lib/class/GenericGetStructureMain.js'
Maria10QueryBuilder     = require '../../../../lib/class/Maria10QueryBuilder.js'
Relation                = require '../../../../lib/class/Relation.js'
Table                   = require '../../../../lib/class/Table.js'

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
api                 = undefined
builder             = undefined
connection          = undefined
dbStructure         = undefined
errorObj            = undefined
field               = undefined
getStructure        = undefined
maria10QueryBuilder = undefined
mocksUtils          = undefined
queryStructure      = undefined
relation            = undefined
stub                = undefined
stub2               = undefined
table               = undefined
val                 = undefined

describe 'Maria10QueryBuilder class', ->

    describe 'buildInnerJoin', ->

        beforeEach (done) ->
            badObj              = null
            mocksUtils          = clone mocks
            relation            = null
            val                 = undefined
            api                 = mocksUtils.api
            connection          = mocksUtils.connection
            dbStructure         = new DatabaseStructure()
            table               = new Table({name: 'foo'})
            dbStructure.addTable table
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )

            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            val = maria10QueryBuilder.buildInnerJoin()
            val.should.be.instanceof apiErrors.ParameterError

        ###*
        # Check with a bad table param
        ###
        it 'should reject if bad param', ->
            val = maria10QueryBuilder.buildInnerJoin(null, field)
            val.should.be.instanceof apiErrors.ParameterError

        ###*
        # Check with a bad field param
        ###
        it 'should reject if bad param', ->
            val = maria10QueryBuilder.buildInnerJoin(table, null)
            val.should.be.instanceof apiErrors.ParameterError

        ###*
        # Check with good params
        ###
        it 'should return an inner join string', ->
            val = maria10QueryBuilder.buildInnerJoin(table, field)
            val.should.be.eql 'INNER JOIN barr ON foo.bar = barr.fooo'

    describe 'buildLeftOuterJoin', ->

        beforeEach (done) ->
            badObj              = null
            mocksUtils          = clone mocks
            val                 = undefined
            api                 = mocksUtils.api
            connection          = mocksUtils.connection
            dbStructure         = new DatabaseStructure()
            table               = new Table({name: 'foo'})
            dbStructure.addTable table
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )

            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            mocksUtils.dbStructureRelation.isInverse    = false
            field       = new Field mocksUtils.dbStructureField
            relation    = new Relation mocksUtils.dbStructureRelation
            table       = new Table mocksUtils.dbStructureTable
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            val = maria10QueryBuilder.buildLeftOuterJoin()
            val.should.be.instanceof apiErrors.ParameterError

        ###*
        # Check with a bad table param
        ###
        it 'should reject if bad param', ->
            val = maria10QueryBuilder.buildLeftOuterJoin(null, field, relation)
            val.should.be.instanceof apiErrors.ParameterError

        ###*
        # Check with only a bad field param
        ###
        it 'should reject if bad param', ->
            val = maria10QueryBuilder.buildLeftOuterJoin(table, null, relation)
            val.should.be.eql 'LEFT OUTER JOIN bar ON foo.foo = bar.foobar'

        ###*
        # Check with only a bad relation param
        ###
        it 'should return an inner join string', ->
            val = maria10QueryBuilder.buildLeftOuterJoin(table, field, null)
            val.should.be.eql 'LEFT OUTER JOIN barr ON foo.bar = barr.fooo'

        ###*
        # Check with bad field and relation params
        ###
        it 'should return an inner join string', ->
            val = maria10QueryBuilder.buildLeftOuterJoin(table, '', null)
            val.should.be.instanceof Array
            val.length.should.be.eql 2
            val[0].should.be.instanceof apiErrors.ParameterError

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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            maria10QueryBuilder.buildGetFromSection()
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            maria10QueryBuilder.buildGetFromSection(null, ['foo'], dbStructure)
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            maria10QueryBuilder.buildGetFromSection('foo', null, dbStructure)
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
                api,
                connection,
                getStructure,
                false,
                dbStructure
            )
            maria10QueryBuilder.buildGetFromSection('foo', ['foo'], null)
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
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

            maria10QueryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'INNER JOIN barr ON foo.bar = barr.fooo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
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

            maria10QueryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'LEFT OUTER JOIN barr ON foo.bar = barr.fooo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
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
            getStructure        = new GenericGetStructureMain('foo', dbStructure)
            maria10QueryBuilder = new Maria10QueryBuilder(
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

            maria10QueryBuilder.buildGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                )
