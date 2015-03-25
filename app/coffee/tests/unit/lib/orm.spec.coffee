'use strict'

###*
# @fileOverview Unit tests for orm lib
###

# require packages
clone               = require 'clone'
DatabaseStructure   = require '../../../lib/class/DatabaseStructure.js'
Field               = require '../../../lib/class/Field.js'
mocks               = require '../_mocks.js'
ormUtils            = require '../../../lib/orm.js'
Relation            = require '../../../lib/class/Relation.js'
rmErrors            = require '../../../lib/errors.js'
sinon               = require 'sinon'
should              = require 'should'
Table               = require '../../../lib/class/Table.js'

# declare variables
badObj      = undefined
dbStructure = undefined
field       = undefined
mocksUtils  = clone mocks
relation    = undefined
stub        = undefined
stub2       = undefined
table       = undefined
val         = undefined

describe 'ORM lib', ->

    describe 'sortSelectByDepth', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            ormUtils.sortSelectByDepth()
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
            ormUtils.sortSelectByDepth([null])
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
            ormUtils.sortSelectByDepth(['a', 'a.b.c', 'a.b'])
                .then(
                    (result) ->
                        result[0].should.be.eql 'a.b.c'
                        result[1].should.be.eql 'a.b'
                        result[2].should.be.eql 'a'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'buildInnerJoin', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            relation    = null
            val         = undefined

            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            val = ormUtils.buildInnerJoin()
            val.should.be.instanceof rmErrors.ParameterError

        ###*
        # Check with a bad table param
        ###
        it 'should reject if bad param', ->
            val = ormUtils.buildInnerJoin(null, field)
            val.should.be.instanceof rmErrors.ParameterError

        ###*
        # Check with a bad field param
        ###
        it 'should reject if bad param', ->
            val = ormUtils.buildInnerJoin(table, null)
            val.should.be.instanceof rmErrors.ParameterError

        ###*
        # Check with good params
        ###
        it 'should return an inner join string', ->
            val = ormUtils.buildInnerJoin(table, field)
            val.should.be.eql 'INNER JOIN foo.bar = barr.fooo'

    describe 'buildLeftOuterJoin', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined

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
            val = ormUtils.buildLeftOuterJoin()
            val.should.be.instanceof rmErrors.ParameterError

        ###*
        # Check with a bad table param
        ###
        it 'should reject if bad param', ->
            val = ormUtils.buildLeftOuterJoin(null, field, relation)
            val.should.be.instanceof rmErrors.ParameterError

        ###*
        # Check with only a bad field param
        ###
        it 'should reject if bad param', ->
            val = ormUtils.buildLeftOuterJoin(table, null, relation)
            val.should.be.eql 'LEFT OUTER JOIN foo ON foo.foo = bar.foobar'

        ###*
        # Check with only a bad relation param
        ###
        it 'should return an inner join string', ->
            val = ormUtils.buildLeftOuterJoin(table, field, null)
            val.should.be.eql 'LEFT OUTER JOIN foo ON foo.bar = barr.fooo'

        ###*
        # Check with bad field and relation params
        ###
        it 'should return an inner join string', ->
            val         = ormUtils.buildLeftOuterJoin(table, '', null)
            val.should.be.instanceof Array
            val.length.should.be.eql 2
            val[0].should.be.instanceof rmErrors.ParameterError

    describe 'buildGenericGetFromSection', ->

        beforeEach (done) ->
            badObj      = null
            dbStructure = new DatabaseStructure()
            field       = undefined
            mocksUtils  = clone mocks
            stub        = null
            stub2       = null
            table       = null
            val         = undefined
            done()

        afterEach (done) ->
            stub.restore()  if stub?.restore?
            stub2.restore() if stub2?.restore?
            done()

        ###*
        # Check without param
        ###
        it 'should reject if no param', ->
            ormUtils.buildGenericGetFromSection()
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
            ormUtils.buildGenericGetFromSection(null, ['foo'], dbStructure)
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
            ormUtils.buildGenericGetFromSection('foo', null, dbStructure)
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
            ormUtils.buildGenericGetFromSection('foo', ['foo'], null)
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

            ormUtils.buildGenericGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'INNER JOIN foo.bar = barr.fooo'
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

            ormUtils.buildGenericGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        result.should.be.eql 'LEFT OUTER JOIN foo ON foo.bar = barr.fooo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check reject if no relation param
        ###
        it 'should resolve if good fk param', ->
            mocksUtils.dbStructureField.refColumnName   = 'fooo'
            mocksUtils.dbStructureField.refTableName    = 'barr'
            field   = new Field mocksUtils.dbStructureField
            table   = new Table mocksUtils.dbStructureTable
            table.addField field
            dbStructure.addTable table
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

            ormUtils.buildGenericGetFromSection('foo', ['bar'], dbStructure)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof Array
                )

    describe 'isListOfValue', ->

        ###*
        # Check without param
        ###
        it 'should return false', ->
            ormUtils.isListOfValue().should.be.false

        ###*
        # Check with a 'in' param
        ###
        it 'should return true', ->
            ormUtils.isListOfValue('in').should.be.true

        ###*
        # Check with a 'not in' param
        ###
        it 'should return true', ->
            ormUtils.isListOfValue('not in').should.be.true

        ###*
        # Check with a '=' param
        ###
        it 'should return false', ->
            ormUtils.isListOfValue('=').should.be.false
