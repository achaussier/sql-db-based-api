'use strict'

###*
# @fileOverview Tests about DatabaseStructure class
###

# require packages
clone = require 'clone'
mocks = require '../../_mocks.js'
DatabaseStructure = require '../../../../lib/databaseStructure/DatabaseStructure.js'
Table = require '../../../../lib/databaseStructure/Table.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null
val2 = null
val3 = null

describe 'Database structure : DatabaseStructure class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        val2 = null
        val3 = null
        done()

    it 'should create new DatabaseStructure', ->
        val = new DatabaseStructure()
        val.should.be.instanceof DatabaseStructure
        val.should.have.keys [
            'tables'
        ]

    it 'should add a new table if not exists', ->
        val = new DatabaseStructure()
        val2 = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof DatabaseStructure
        val2.should.be.instanceof Table
        val.addTable(val2).should.be.true

    it 'should not add a new table if already exists', ->
        val = new DatabaseStructure()
        val2 = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof DatabaseStructure
        val2.should.be.instanceof Table
        val.addTable(val2).should.be.true
        val.addTable(val2).should.be.false

    it 'should get table if exists', ->
        val = new DatabaseStructure()
        val2 = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof DatabaseStructure
        val2.should.be.instanceof Table
        val.addTable(val2).should.be.true
        val.getTable('foo').name.should.be.eql 'foo'

    it 'should not get table if not exists', ->
        val = new DatabaseStructure()
        val2 = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof DatabaseStructure
        val2.should.be.instanceof Table
        val.addTable(val2).should.be.true
        should.not.exists(val.getTable('foo2'))

    it 'should render same as v1', ->
        val = new DatabaseStructure()
        val2 = new Table(mocksUtils.dbStructureTable)
        val.should.be.instanceof DatabaseStructure
        val2.should.be.instanceof Table
        val.addTable(val2).should.be.true
        val3 = val.versionOneRender()
        val3.should.have.keys 'struct'
        val3.struct.should.have.keys 'objects'
        val3.struct.objects.should.have.keys 'foo'
