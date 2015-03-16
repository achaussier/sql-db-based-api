'use strict'

###*
# @fileOverview Tests about database structure UniqueIndex class
###

# require packages
clone = require 'clone'
UniqueIndex = require '../../../../lib/databaseStructure/UniqueIndex.js'
mocks = require '../../_mocks.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null

describe 'Database structure : UniqueIndex class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        done()

    it 'should create new UniqueIndex', ->
        val = new UniqueIndex(mocksUtils.dbStructureUniqueIndex)
        val.should.be.instanceof UniqueIndex
        val.should.have.keys [
            'columns'
            'name'
            'tableName'
        ]

    it 'should not be possible to add same column', ->
        val = new UniqueIndex(mocksUtils.dbStructureUniqueIndex)
        val.should.be.instanceof UniqueIndex
        val.addColumn('foobar').should.be.false
        val.columns.length.should.be.eql 1

     it 'should be possible to add another column', ->
        val = new UniqueIndex(mocksUtils.dbStructureUniqueIndex)
        val.should.be.instanceof UniqueIndex
        val.addColumn('foobar2').should.be.true
        val.columns.length.should.be.eql 2
