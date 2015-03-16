'use strict'

###*
# @fileOverview Tests about database structure Table class
###

# require packages
clone = require 'clone'
mocks = require '../../_mocks.js'
Field = require '../../../../lib/databaseStructure/Field.js'
Relation = require '../../../../lib/databaseStructure/Relation.js'
Table = require '../../../../lib/databaseStructure/Table.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null
val2 = null

describe 'Database structure : Table class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        val2 = null
        done()

    it 'should create new table', ->
        val = new Table('foo')
        val.should.be.instanceof Table
        val.should.have.keys [
            'name'
            'fields'
            'uniqueIndexes'
            'relations'
            'isView'
        ]

    it 'should add a new field if not exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Table
        val2.should.be.instanceof Field
        val.addField(val2).should.be.true

    it 'should not add a new field if already exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Table
        val2.should.be.instanceof Field
        val.addField(val2).should.be.true
        val.addField(val2).should.be.false

    it 'should add a new relation if not exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = new Relation(mocksUtils.dbStructureRelation)
        val.should.be.instanceof Table
        val2.should.be.instanceof Relation
        val.addRelation(val2).should.be.true

    it 'should not add a new relation if already exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = new Relation(mocksUtils.dbStructureRelation)
        val.should.be.instanceof Table
        val2.should.be.instanceof Relation
        val.addRelation(val2).should.be.true
        val.addRelation(val2).should.be.false

    it 'should add a new index part if not exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true

    it 'should not add a new index part if part already exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.false

    it 'should add a new index part if part not exists', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true

        mocksUtils.dbStructureUniqueIndex.columnName = 'foo'
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true

    it 'should return v1 simple fields', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getSimpleFieldsForV1()
        Object.keys(val2).length.should.be.eql 2
        val2.should.have.keys [
            'bar'
            'foobar'
        ]
        val2['bar'].should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'maxLength'
            'defaultValue'
            'isAutoIncrement'
        ]

    it 'should return v1 complex fields', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getComplexFieldsForV1()
        Object.keys(val2).length.should.be.eql 1
        val2.should.have.keys [
            'foobar2'
        ]
        val2['foobar2'].should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]

    it 'should return required fields', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getRequiredFieldsName()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 2
        val2.indexOf('bar').should.not.be.eql -1
        val2.indexOf('foobar2').should.not.be.eql -1

    it 'should return optional fields', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getOptionalFieldsName()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 1
        val2.indexOf('foobar').should.not.be.eql -1

    it 'should return aliases for v1 render', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getAliasesForV1()
        val2.should.have.keys 'bar'
        val2.bar.should.be.eql 'foobar2'

    it 'should return inverse aliases for v1 render', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getInverseAliasesForV1()
        val2.should.have.keys 'foobar2'
        val2.foobar2.should.be.eql 'bar'

    it 'should return primary key if only one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[1].columnKey       = 'pri'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getPrimaryKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 1
        val2.indexOf('foobar').should.not.be.eql -1

    it 'should return primary key if more than one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[1].columnKey       = 'pri'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val2[2].columnKey       = 'pri'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getPrimaryKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 2
        val2.indexOf('foobar').should.not.be.eql -1
        val2.indexOf('foobar2').should.not.be.eql -1

    it 'should return foreign key if only one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[1].columnKey       = 'pri'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getForeignKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 1
        val2.indexOf('foobar2').should.not.be.eql -1

    it 'should return foreign key if more than one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2.push(new Field(mocksUtils.dbStructureField))
        val2[1].columnName      = 'foobar'
        val2[1].nullable        = 'yes'
        val2[1].columnKey       = 'pri'
        val2[1].refTableName    = 'bar'
        val2[1].refTableColumn  = 'barA'
        val2[2].columnName      = 'foobar2'
        val2[2].refTableName    = 'bar'
        val2[2].refTableColumn  = 'barA'
        val2[2].columnKey       = 'pri'
        val.should.be.instanceof Table
        val.addField(val2[0]).should.be.true
        val.addField(val2[1]).should.be.true
        val.addField(val2[2]).should.be.true
        val2 = val.getForeignKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 2
        val2.indexOf('foobar').should.not.be.eql -1
        val2.indexOf('foobar2').should.not.be.eql -1

    it 'should return inverse foreign key if only one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        mocksUtils.dbStructureRelation.isInverse = true
        val2.push(new Relation(mocksUtils.dbStructureRelation))
        val.should.be.instanceof Table
        val.addRelation(val2[0]).should.be.true
        val2 = val.getInverseForeignKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 1
        val2[0].should.be.eql 'bar'

    it 'should return inverse foreign key if more than one', ->
        val = new Table(mocksUtils.dbStructureTable)
        val2 = []
        mocksUtils.dbStructureRelation.isInverse = true
        val2.push(new Relation(mocksUtils.dbStructureRelation))
        mocksUtils.dbStructureRelation.destTable = 'foobar2'
        val2.push(new Relation(mocksUtils.dbStructureRelation))
        val.should.be.instanceof Table
        val.addRelation(val2[0]).should.be.true
        val.addRelation(val2[1]).should.be.true
        val2 = val.getInverseForeignKeys()
        val2.should.be.instanceof Array
        val2.length.should.be.eql 2
        val2[0].should.be.eql 'bar'
        val2[1].should.be.eql 'foobar2'

    it 'should return unique indexes by colums', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.columnName = 'foo2'
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        val2 = val.getUniqueIndexesByColumn()
        val2.should.have.keys [
            'foo2'
            'foobar'
        ]
        val2.foo2.should.be.instanceof Array
        val2.foo2.length.should.be.eql 1
        val2.foo2.indexOf('foo').should.not.be.eql -1
        val2.foobar.should.be.instanceof Array
        val2.foobar.length.should.be.eql 1
        val2.foobar.indexOf('foo').should.not.be.eql -1

    it 'should return unique indexes by index name', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.columnName = 'foo2'
        val.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        val2 = val.getUniqueIndexesByName()
        val2.should.have.keys 'foo'
        val2.foo.should.be.instanceof Array
        val2.foo.length.should.be.eql 2
        val2.foo.indexOf('foo2').should.not.be.eql -1
        val2.foo.indexOf('foobar').should.not.be.eql -1

    it 'should return a version one database structure for table', ->
        val = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof Table
        val2 = val.versionOneRender()
        val2.should.have.keys [
            'aliases'
            'fields'
            'foreignKeys'
            'inverseAliases'
            'inverseForeignKeys'
            'isView'
            'parameters'
            'primaryKeys'
            'uniqueIndexes'
        ]
        val2.fields.should.have.keys [
            'complex'
            'simple'
        ]
        val2.parameters.should.have.keys [
            'optional'
            'required'
        ]
        val2.uniqueIndexes.should.have.keys [
            'byColumnName'
            'byIndexName'
        ]
        val2.foreignKeys.should.be.instanceof Array
        val2.inverseForeignKeys.should.be.instanceof Array
        val2.parameters.optional.should.be.instanceof Array
        val2.parameters.required.should.be.instanceof Array
        val2.primaryKeys.should.be.instanceof Array
