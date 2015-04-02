'use strict'

###*
# @fileOverview Tests about database structure Field class
###

###*
# required modules
###
clone   = require 'clone'
Field   = require '../../../../lib/class/Field.js'
mocks   = require '../../_mocks.js'
should  = require 'should'

###*
# Declare variables
###
mocksUtils  = undefined
field       = undefined

describe 'Database structure : Field class', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        field       = null
        done()

    ###*
    # Check with a valid field
    ###
    it 'should create new field', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.should.have.keys [
            'tableSchema'
            'tableName'
            'columnName'
            'ordinalPosition'
            'defaultValue'
            'nullable'
            'dataType'
            'charMaxLength'
            'charOctetLength'
            'numPrecision'
            'numScale'
            'datetimePrecision'
            'charSetName'
            'collationName'
            'columnType'
            'columnKey'
            'extra'
            'refTableName'
            'refColumnName'
            'tableType'
            'uniqueIndexName'
        ]

    ###*
    # Check with no primary key field
    ###
    it 'should return false if it is not a primary key', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isPrimaryKey().should.be.false

    ###*
    # Check with a not required field
    ###
    it 'should return false if it is not required', ->
        mocksUtils.dbStructureField.isNullable = 'yes'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isRequired().should.be.false

    ###*
    # Check with a not nullable field
    ###
    it 'should return false if it is not nullable', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isNullable().should.be.false

    ###*
    # Check with a non uto increment field
    ###
    it 'should return false if it is not an auto increment', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isAutoIncrement().should.be.false

    ###*
    # Check with a primary key field
    ###
    it 'should return true if it is a primary key', ->
        mocksUtils.dbStructureField.columnKey = 'pri'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isPrimaryKey().should.be.true

    ###*
    # Check with a required field
    ###
    it 'should return true if it is required', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isRequired().should.be.true

    ###*
    # Check with an autoincrement field
    ###
    it 'should return true if it is auto increment', ->
        mocksUtils.dbStructureField.extra = 'auto_increment'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isAutoIncrement().should.be.true

    ###*
    # Check with a nullable field
    ###
    it 'should return true if it is a nullable', ->
        mocksUtils.dbStructureField.isNullable = 'yes'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.isNullable().should.be.true

    ###*
    # Check with integer field
    ###
    it 'should return numPrecision field for getMaxLength if integer', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.getMaxLength().should.be.eql 11

    ###*
    # Check with varchar field
    ###
    it 'should return charMaxLength field for getMaxLength if varchar', ->
        mocksUtils.dbStructureField.dataType = 'varchar'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.getMaxLength().should.be.eql 255

    ###*
    # Check with text field
    ###
    it 'should return charMaxLength field for getMaxLength if text', ->
        mocksUtils.dbStructureField.dataType = 'text'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        field.getMaxLength().should.be.eql 255

    ###*
    # Check with other filed type
    ###
    it 'should return null for getMaxLength if not int, varchar or text', ->
        mocksUtils.dbStructureField.dataType = 'foo'
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        should.not.exists(field.getMaxLength())
