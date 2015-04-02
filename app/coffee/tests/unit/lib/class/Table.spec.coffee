'use strict'

###*
# @fileOverview Tests about database structure Table class
###

###*
# Required custom classes
###
Field       = require '../../../../lib/class/Field.js'
Relation    = require '../../../../lib/class/Relation.js'
Table       = require '../../../../lib/class/Table.js'

###*
# Required modules
###
clone   = require 'clone'
mocks   = require '../../_mocks.js'
should  = require 'should'

###*
# Declare variables
###
dbStructure = undefined
errorObj    = undefined
field       = undefined
fields      = undefined
mocksUtils  = undefined
relation    = undefined
relations   = undefined
render      = undefined
table       = undefined
val         = undefined
val2        = undefined

describe 'Database structure : Table class', ->

    beforeEach (done) ->
        errorObj    = null
        mocksUtils  = clone mocks
        field       = new Field(mocksUtils.dbStructureField)
        fields      = []
        relation    = new Relation(mocksUtils.dbStructureRelation)
        relations   = []
        render      = null
        table       = new Table(mocksUtils.dbStructureTable)
        val         = null
        fields.push(new Field(mocksUtils.dbStructureField))
        fields.push(new Field(mocksUtils.dbStructureField))
        fields.push(new Field(mocksUtils.dbStructureField))

        done()

    ###*
    # Check create table
    ###
    it 'should create new table', ->
        table.should.be.instanceof Table
        table.should.have.keys [
            'name'
            'fields'
            'uniqueIndexes'
            'relations'
            'isView'
        ]

    ###*
    # Check with new field
    ###
    it 'should add a new field if not exists', ->
        field.should.be.instanceof Field
        table.addField(field).should.be.true

    ###*
    # Check add twice a field
    ###
    it 'should not add a new field if already exists', ->
        table.addField(field).should.be.true
        table.addField(field).should.be.false

    ###*
    # Check with new relation
    ###
    it 'should add a new relation if not exists', ->
        relation.should.be.instanceof Relation
        table.addRelation(relation).should.be.true

    ###*
    # Check add twice a relation
    ###
    it 'should not add a new relation if already exists', ->
        table.addRelation(relation).should.be.true
        table.addRelation(relation).should.be.false

    ###*
    # Check with new index
    ###
    it 'should add a new index part if not exists', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true

    ###*
    # Check add twice a index part
    ###
    it 'should not add a new index part if part already exists', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.false

    ###*
    # Check with new index part for existing index
    ###
    it 'should add a new index part if part not exists', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.columnName = 'foo'
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.false

    ###*
    # Check with new index
    ###
    it 'should add a new index part if index not exists', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.indexName = 'bar'
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true

    ###*
    # Check with simple fields
    ###
    it 'should return v1 simple fields', ->
        fields[1].columnName      = 'foobar'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getSimpleFieldsForV1()
        Object.keys(val).length.should.be.eql 2
        val.should.have.keys [
            'bar'
            'foobar'
        ]
        val['bar'].should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'maxLength'
            'defaultValue'
            'isAutoIncrement'
        ]

    ###*
    # Check with foreign keys
    ###
    it 'should return v1 complex fields', ->
        fields[1].columnName      = 'foobar'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getComplexFieldsForV1()
        Object.keys(val).length.should.be.eql 1
        val.should.have.keys [
            'foobar2'
        ]
        val['foobar2'].should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]

    ###*
    # Check with relation (inverse and not inverse)
    ###
    it 'should return v1 complex fields', ->
        table.addRelation(relation).should.be.true
        mocksUtils.dbStructureRelation.isInverse = true
        mocksUtils.dbStructureRelation.destColumn = 'foo'
        table.addRelation(new Relation mocksUtils.dbStructureRelation).should.be.true
        val = table.getComplexFieldsForV1()
        Object.keys(val).length.should.be.eql 1
        val.should.have.keys [
            'bar'
        ]
        val['bar'].should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]

    ###*
    # Check with required fields defined
    ###
    it 'should return required fields', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getRequiredFieldsName()
        val.should.be.instanceof Array
        val.length.should.be.eql 2
        val.indexOf('bar').should.not.be.eql -1
        val.indexOf('foobar2').should.not.be.eql -1

    ###*
    # Check with optional fields defined
    ###
    it 'should return optional fields', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getOptionalFieldsName()
        val.should.be.instanceof Array
        val.length.should.be.eql 1
        val.indexOf('foobar').should.not.be.eql -1

    ###*
    # Check with fields without same name than dest table
    ###
    it 'should return aliases for v1 render', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getAliasesForV1()
        val.should.have.keys 'bar'
        val.bar.should.be.eql 'foobar2'

    ###*
    # Check with fields without same name than dest table
    ###
    it 'should return inverse aliases for v1 render', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getInverseAliasesForV1()
        val.should.have.keys 'foobar2'
        val.foobar2.should.be.eql 'bar'

    ###*
    # Check with one primary key field
    ###
    it 'should return primary key if only one', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[1].columnKey       = 'pri'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getPrimaryKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 1
        val.indexOf('foobar').should.not.be.eql -1

    ###*
    # Check with many primary key fields
    ###
    it 'should return primary key if more than one', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[1].columnKey       = 'pri'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        fields[2].columnKey       = 'pri'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getPrimaryKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 2
        val.indexOf('foobar').should.not.be.eql -1
        val.indexOf('foobar2').should.not.be.eql -1

    ###*
    # Check with one foreign key field
    ###
    it 'should return foreign key if only one', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[1].columnKey       = 'pri'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getForeignKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 1
        val.indexOf('foobar2').should.not.be.eql -1

    ###*
    # Check with many foreign key fields
    ###
    it 'should return foreign key if more than one', ->
        fields[1].columnName      = 'foobar'
        fields[1].nullable        = 'yes'
        fields[1].columnKey       = 'pri'
        fields[1].refTableName    = 'bar'
        fields[1].refTableColumn  = 'barA'
        fields[2].columnName      = 'foobar2'
        fields[2].refTableName    = 'bar'
        fields[2].refTableColumn  = 'barA'
        fields[2].columnKey       = 'pri'
        table.addField(fields[0]).should.be.true
        table.addField(fields[1]).should.be.true
        table.addField(fields[2]).should.be.true
        val = table.getForeignKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 2
        val.indexOf('foobar').should.not.be.eql -1
        val.indexOf('foobar2').should.not.be.eql -1

    ###*
    # Check with one inverse foreign key field
    ###
    it 'should return inverse foreign key if only one', ->
        mocksUtils.dbStructureRelation.isInverse = true
        relations.push(new Relation(mocksUtils.dbStructureRelation))
        table.addRelation(relations[0]).should.be.true
        val = table.getInverseForeignKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 1
        val[0].should.be.eql 'bar'

    ###*
    # Check with many foreign key fields
    ###
    it 'should return inverse foreign key if more than one', ->
        mocksUtils.dbStructureRelation.isInverse = true
        relations.push(new Relation(mocksUtils.dbStructureRelation))
        mocksUtils.dbStructureRelation.destTable = 'foobar2'
        relations.push(new Relation(mocksUtils.dbStructureRelation))
        table.addRelation(relations[0]).should.be.true
        table.addRelation(relations[1]).should.be.true
        val = table.getInverseForeignKeys()
        val.should.be.instanceof Array
        val.length.should.be.eql 2
        val[0].should.be.eql 'bar'
        val[1].should.be.eql 'foobar2'

    ###*
    # Check with one index with two columns
    ###
    it 'should return unique indexes by colums', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.columnName = 'foo2'
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        val = table.getUniqueIndexesByColumn()
        val.should.have.keys [
            'foo2'
            'foobar'
        ]
        val.foo2.should.be.instanceof Array
        val.foo2.length.should.be.eql 1
        val.foo2.indexOf('foo').should.not.be.eql -1
        val.foobar.should.be.instanceof Array
        val.foobar.length.should.be.eql 1
        val.foobar.indexOf('foo').should.not.be.eql -1

    ###*
    # Check with one index with two columns
    ###
    it 'should return unique indexes by index name', ->
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        mocksUtils.dbStructureUniqueIndex.columnName = 'foo2'
        table.addUniqueIndexPart(mocksUtils.dbStructureUniqueIndex).should.be.true
        val = table.getUniqueIndexesByName()
        val.should.have.keys 'foo'
        val.foo.should.be.instanceof Array
        val.foo.length.should.be.eql 2
        val.foo.indexOf('foo2').should.not.be.eql -1
        val.foo.indexOf('foobar').should.not.be.eql -1

    ###*
    # Check with table v1 render of database structure
    ###
    it 'should return a version one database structure for table', ->
        render = table.versionOneRender()
        render.should.have.keys [
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
        render.fields.should.have.keys [
            'complex'
            'simple'
        ]
        render.parameters.should.have.keys [
            'optional'
            'required'
        ]
        render.uniqueIndexes.should.have.keys [
            'byColumnName'
            'byIndexName'
        ]
        render.foreignKeys.should.be.instanceof Array
        render.inverseForeignKeys.should.be.instanceof Array
        render.parameters.optional.should.be.instanceof Array
        render.parameters.required.should.be.instanceof Array
        render.primaryKeys.should.be.instanceof Array

    describe 'getField', ->
        beforeEach (done) ->
            mocksUtils  = clone mocks
            field       = new Field(mocksUtils.dbStructureField)
            table       = new Table(mocksUtils.dbStructureTable)
            table.addField field
            done()

        ###*
        # Check with existing field
        ###
        it 'should get a field', ->
            should.exists table.getField(mocksUtils.dbStructureField.columnName)

        ###*
        # Check with existing field
        ###
        it 'should get null', ->
            should.not.exists table.getField('foo')

    describe 'isForeignKey', ->
        beforeEach (done) ->
            mocksUtils  = clone mocks
            field       = null
            table       = new Table(mocksUtils.dbStructureTable)
            done()

        ###*
        # Check with existing foreign key
        ###
        it 'should return true', ->
            mocksUtils.dbStructureField.refTableName    = 'refTableName'
            mocksUtils.dbStructureField.refTableColumn  = 'refTableColumn'
            field = new Field(mocksUtils.dbStructureField)
            table.addField field
            table.isForeignKey(mocksUtils.dbStructureField.columnName).should.be.true

        ###*
        # Check without foreign key
        ###
        it 'should return false', ->
            field = new Field(mocksUtils.dbStructureField)
            table.addField field
            table.isForeignKey(mocksUtils.dbStructureField.columnName).should.be.false

    describe 'isInverseForeignKey', ->
        beforeEach (done) ->
            mocksUtils  = clone mocks
            relation    = null
            table       = null
            field       = null
            done()

        ###*
        # Check with existing inverse foreign key
        ###
        it 'should return true', ->
            mocksUtils.dbStructureRelation.isInverse = true
            table       = new Table(mocksUtils.dbStructureTable)
            relation    = new Relation(mocksUtils.dbStructureRelation)
            table.addRelation relation
            table.isInverseForeignKey(mocksUtils.dbStructureRelation.destTable).should.be.true

        ###*
        # Check without inverse foreign key
        ###
        it 'should return false', ->
            table       = new Table(mocksUtils.dbStructureTable)
            field       = new Field(mocksUtils.dbStructureField)
            relation    = new Relation(mocksUtils.dbStructureRelation)
            table.addRelation relation
            table.addField field
            table.isInverseForeignKey('bar').should.be.false

    describe 'isRelationExists', ->
        beforeEach (done) ->
            errorObj    = null
            mocksUtils  = clone mocks
            relation    = null
            table       = null
            field       = null
            done()

        ###*
        # Check with foreign key
        ###
        it 'should return true', ->
            mocksUtils.dbStructureField.refTableName    = 'refTableName'
            mocksUtils.dbStructureField.refTableColumn  = 'refTableColumn'
            table   = new Table(mocksUtils.dbStructureTable)
            field   = new Field(mocksUtils.dbStructureField)
            table.addField field
            table.isRelationExists(mocksUtils.dbStructureField.columnName).should.be.true

        ###*
        # Check with relation
        ###
        it 'should return true', ->
            mocksUtils.dbStructureRelation.isInverse = true
            table       = new Table(mocksUtils.dbStructureTable)
            relation    = new Relation(mocksUtils.dbStructureRelation)
            table.addRelation relation
            table.isRelationExists(mocksUtils.dbStructureRelation.destTable).should.be.true

        ###*
        # Check without relation
        ###
        it 'should return false', ->
            table       = new Table(mocksUtils.dbStructureTable)
            field       = new Field(mocksUtils.dbStructureField)
            relation    = new Relation(mocksUtils.dbStructureRelation)
            table.addRelation relation
            table.addField field
            table.isRelationExists('bar').should.be.false

    describe 'getInverseForeignKey', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            relation    = new Relation(mocksUtils.dbStructureRelation)
            table       = new Table(mocksUtils.dbStructureTable)
            val         = null
            done()

        ###*
        # Check with relation (inverse and not inverse)
        ###
        it 'should return inverse foreign key', ->
            table.addRelation(relation).should.be.true
            mocksUtils.dbStructureRelation.isInverse = true
            mocksUtils.dbStructureRelation.destColumn = 'foo'
            table.addRelation(new Relation mocksUtils.dbStructureRelation).should.be.true
            val = table.getInverseForeignKey('bar')
            val.length.should.be.eql 3
            val[0].should.be.eql 'b'

    describe 'getUniqueIndexesByColumn', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            table       = new Table(mocksUtils.dbStructureTable)
            val         = null
            done()

        ###*
        # Check with relation (inverse and not inverse)
        ###
        it 'should return unique indexes', ->
            table.uniqueIndexes = [
                {
                    columns : ['b', 'c']
                    name    : 'foo'
                }
                {
                    columns : ['a', 'b']
                    name    : 'bar'
                }
            ]
            val = table.getUniqueIndexesByColumn()
            Object.keys(val).length.should.be.eql 3
