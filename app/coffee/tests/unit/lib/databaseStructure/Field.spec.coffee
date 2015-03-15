'use strict'

###*
# @fileOverview Tests about database structure Field class
###

# require packages
clone = require 'clone'
Field = require '../../../../lib/databaseStructure/Field.js'
mocks = require '../../_mocks.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null

describe 'Database structure : Field class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        done()

    it 'should create new field', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.should.have.keys [
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
        ]

    it 'should return false if it is not a primary key', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isPrimaryKey().should.be.false

    it 'should return false if it is not required', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isRequired().should.be.false

    it 'should return false if it is not nullable', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isNullable().should.be.false

    it 'should return false if it is not an auto increment', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isAutoIncrement().should.be.false

    it 'should return true if it is a primary key', ->
        mocksUtils.dbStructureField.columnKey = 'pri'
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isPrimaryKey().should.be.true

    it 'should return true if it is required', ->
        mocksUtils.dbStructureField.isNullable = 'yes'
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isRequired().should.be.true

    it 'should return true if it is auto increment', ->
        mocksUtils.dbStructureField.extra = 'auto_increment'
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isAutoIncrement().should.be.true

    it 'should return true if it is a nullable', ->
        mocksUtils.dbStructureField.isNullable = 'yes'
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val.isNullable().should.be.true
