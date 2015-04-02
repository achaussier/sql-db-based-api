'use strict'

###*
# @fileOverview Tests about DatabaseStructure class
###

###*
# Required modules
###
clone               = require 'clone'
mocks               = require '../../_mocks.js'
DatabaseStructure   = require '../../../../lib/class/DatabaseStructure.js'
Field               = require '../../../../lib/class/Field.js'
Relation            = require '../../../../lib/class/Relation.js'
Table               = require '../../../../lib/class/Table.js'
sinon               = require 'sinon'
should              = require 'should'

###*
# Declare variables
###
dbStructure = undefined
errorObj    = undefined
field       = undefined
fieldName   = undefined
mocksUtils  = undefined
stub        = undefined
stub2       = undefined
table       = undefined
table2      = undefined
table2Mock  = undefined
tableName   = undefined
v1render    = undefined

describe 'Database structure : DatabaseStructure class', ->

    beforeEach (done) ->
        errorObj    = null
        mocksUtils  = clone mocks
        dbStructure = new DatabaseStructure()
        table       = new Table(mocksUtils.dbStructureTable)
        v1render    = null
        done()

    ###*
    # Check new instance create
    ###
    it 'should create new DatabaseStructure', ->
        dbStructure.should.be.instanceof DatabaseStructure
        dbStructure.should.have.keys [
            'tables'
        ]

    ###*
    # Check add table to structure
    ###
    it 'should add a new table if not exists', ->
        table.should.be.instanceof Table
        dbStructure.addTable(table).should.be.true

    ###*
    # Check with existing table
    ###
    it 'should not add a new table if already exists', ->
        dbStructure.addTable(table).should.be.true
        dbStructure.addTable(table).should.be.false

    ###*
    # Check table getter for existing table
    ###
    it 'should get table if exists', ->
        dbStructure.addTable(table).should.be.true
        dbStructure.getTable('foo').name.should.be.eql 'foo'

    ###*
    # Check table getter for unknown table
    ###
    it 'should not get table if not exists', ->
        dbStructure.addTable(table).should.be.true
        should.not.exists(dbStructure.getTable('foo2'))

    ###*
    # Check v1 render with a table
    ###
    it 'should render same as v1', ->
        dbStructure.addTable(table).should.be.true
        v1render = dbStructure.versionOneRender()
        v1render.should.have.keys 'struct'
        v1render.struct.should.have.keys 'objects'
        v1render.struct.objects.should.have.keys 'foo'

    ###*
    # Check v1 render with a view
    ###
    it 'should render same as v1', ->
        table.isView = true
        dbStructure.addTable(table).should.be.true
        v1render = dbStructure.versionOneRender()
        v1render.should.have.keys 'struct'
        v1render.struct.should.have.keys 'objects'
        v1render.struct.objects.should.not.have.keys 'foo'

    describe 'checkPath', ->

        beforeEach (done) ->
            errorObj    = null
            mocksUtils  = clone mocks
            dbStructure = null
            field       = null
            fieldName   = null
            stub        = null
            stub2       = null
            table       = null
            table2      = null
            table2Mock  = null
            tableName   = null
            v1render    = null
            done()

        afterEach (done) ->
            stub.restore()  if stub?.restore?
            stub2.restore() if stub2?.restore?
            done()

        ###*
        # Check without param
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            dbStructure.checkPath().should.be.false

        ###*
        # Check with a table without field
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            dbStructure.addTable table
            dbStructure.checkPath('foo', mocksUtils.dbStructureTable).should.be.false

        ###*
        # Check with a field not exists in table
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            table.addField field
            dbStructure.addTable table
            dbStructure.checkPath('foo', mocksUtils.dbStructureTable).should.be.false

        ###*
        # Check with a valid field
        ###
        it 'should return true', ->
            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            fieldName       = mocksUtils.dbStructureField.columnName
            tableName       = mocksUtils.dbStructureTable.name
            table.addField(field).should.be.true
            dbStructure.addTable(table).should.be.true
            dbStructure.checkPath(fieldName, tableName).should.be.true

        ###*
        # Check with a valid foreign key field
        ###
        it 'should return true', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2'
            mocksUtils.dbStructureField.refTableName    = 'foo2'
            mocksUtils.dbStructureField.refColumnName   = 'bar2'

            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            table2          = new Table(table2Mock)
            fieldName       = mocksUtils.dbStructureField.columnName
            tableName       = mocksUtils.dbStructureTable.name
            table.addField(field).should.be.true
            dbStructure.addTable(table).should.be.true
            dbStructure.addTable(table2).should.be.true
            dbStructure.checkPath(fieldName + '.foo2', tableName).should.be.true

        ###*
        # Check with an invalid inverse foreign key
        ###
        it 'should return true', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2'

            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            tableName       = mocksUtils.dbStructureTable.name
            table2          = new Table(table2Mock)
            stub            = sinon.stub(
                table,
                'isInverseForeignKey'
                ->
                    false
            )
            stub2           = sinon.stub(
                table,
                'getField'
                ->
                    {}
            )

            dbStructure.addTable(table).should.be.true
            dbStructure.addTable(table2).should.be.true
            dbStructure.checkPath(fieldName + '.foo3', tableName).should.be.false

        ###*
        # Check inverse relation table become parent
        ###
        it 'should return true', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2.bar'

            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            tableName       = mocksUtils.dbStructureTable.name
            table2          = new Table(table2Mock)
            stub            = sinon.stub(
                dbStructure,
                'getTable'
                ->
                    getField: ->
                        null
                    isRelationExists: ->
                        true
            )
            dbStructure.checkPath('foo.bar', 'foo').should.be.true



    describe 'containsInverseRelation', ->

        beforeEach (done) ->
            errorObj    = null
            mocksUtils  = clone mocks
            dbStructure = null
            field       = null
            fieldName   = null
            stub        = null
            stub2       = null
            table       = null
            table2      = null
            table2Mock  = null
            tableName   = null
            v1render    = null
            done()

        afterEach (done) ->
            stub.restore()  if stub?.restore?
            stub2.restore() if stub2?.restore?
            done()

        ###*
        # Check without param
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            dbStructure.containsInverseRelation().should.be.false

        ###*
        # Check with a table without field
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            dbStructure.addTable table
            dbStructure.containsInverseRelation('foo', mocksUtils.dbStructureTable).should.be.false

        ###*
        # Check with a field not exists in table
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            table.addField field
            dbStructure.addTable table
            dbStructure.containsInverseRelation('foo', mocksUtils.dbStructureTable).should.be.false

        ###*
        # Check with a valid field
        ###
        it 'should return false', ->
            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            fieldName       = mocksUtils.dbStructureField.columnName
            tableName       = mocksUtils.dbStructureTable.name
            table.addField(field).should.be.true
            dbStructure.addTable(table).should.be.true
            dbStructure.containsInverseRelation(fieldName, tableName).should.be.false

        ###*
        # Check with a valid foreign key field
        ###
        it 'should return false', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2'
            mocksUtils.dbStructureField.refTableName    = 'foo2'
            mocksUtils.dbStructureField.refColumnName   = 'bar2'

            dbStructure     = new DatabaseStructure()
            field           = new Field(mocksUtils.dbStructureField)
            table           = new Table(mocksUtils.dbStructureTable)
            table2          = new Table(table2Mock)
            fieldName       = mocksUtils.dbStructureField.columnName
            tableName       = mocksUtils.dbStructureTable.name
            table.addField(field).should.be.true
            dbStructure.addTable(table).should.be.true
            dbStructure.addTable(table2).should.be.true
            dbStructure.containsInverseRelation(fieldName + '.foo2', tableName).should.be.false

        ###*
        # Check with an invalid inverse foreign key
        ###
        it 'should return false', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2'

            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            tableName       = mocksUtils.dbStructureTable.name
            table2          = new Table(table2Mock)
            stub            = sinon.stub(
                table,
                'isInverseForeignKey'
                ->
                    false
            )
            stub2           = sinon.stub(
                table,
                'getField'
                ->
                    {}
            )

            dbStructure.addTable(table).should.be.true
            dbStructure.addTable(table2).should.be.true
            dbStructure.containsInverseRelation(fieldName + '.foo3', tableName).should.be.false

        ###*
        # Check with a valid inverse foreign key
        ###
        it 'should return true', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2'

            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            tableName       = mocksUtils.dbStructureTable.name
            table2          = new Table(table2Mock)
            stub            = sinon.stub(
                table,
                'isInverseForeignKey'
                ->
                    true
            )


            dbStructure.addTable(table).should.be.true
            dbStructure.addTable(table2).should.be.true
            dbStructure.containsInverseRelation(fieldName + '.foo2', tableName).should.be.true

        ###*
        # Check inverse relation table become parent
        ###
        it 'should return false', ->
            table2Mock      = clone mocksUtils.dbStructureTable
            table2Mock.name = 'foo2.bar'

            dbStructure     = new DatabaseStructure()
            table           = new Table(mocksUtils.dbStructureTable)
            tableName       = mocksUtils.dbStructureTable.name
            table2          = new Table(table2Mock)
            stub            = sinon.stub(
                dbStructure,
                'getTable'
                ->
                    getField: ->
                        null
                    isRelationExists: ->
                        true
                    isInverseForeignKey: ->
                        false
            )
            dbStructure.containsInverseRelation('foo.bar', 'foo').should.be.false
