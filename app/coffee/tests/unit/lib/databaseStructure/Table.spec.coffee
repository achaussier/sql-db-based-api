'use strict'

###*
# @fileOverview Tests about database structure Table class
###

# require packages
Table = require '../../../../lib/databaseStructure/Table.js'
should = require 'should'

errorObj = null
val = null

describe 'Database structure : Table class', ->

    beforeEach (done) ->
        errorObj = null
        vall = null
        done()

    it 'should create new table', ->
        val = new Table('foo')
        val.should.be.instanceof Table
        val.should.have.keys [
            'name'
            'fields'
            'parameters'
            'aliases'
            'inverseAliases'
            'primaryKeys'
            'foreignKeys'
            'inverseForeignKeys'
            'uniqueIndexes'
            'isView'
        ]
