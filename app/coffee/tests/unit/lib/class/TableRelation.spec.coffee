'use strict'

###*
# @fileOverview Tests about database structure TableRelation class
###

# require packages
TableRelation = require '../../../../lib/class/TableRelation.js'
should = require 'should'

errorObj = null
val = null
testObj = null

describe 'Database structure : TableRelation class', ->

    beforeEach (done) ->
        errorObj = null
        done()

    it 'should create new TableRelation', ->
        val = new TableRelation('foo')
        val.should.be.instanceof TableRelation
        val.should.have.keys [
            'name'
            'relations'
            'inverseRelations'
        ]

    it 'should possible to push relation', ->
        val.relations.length.should.be.eql 0
        val.addRelation { foo: 'bar' }
        val.relations.length.should.be.eql 1

    it 'should possible to push inverse relation', ->
        val.inverseRelations.length.should.be.eql 0
        val.addInverseRelation { foo: 'bar' }
        val.inverseRelations.length.should.be.eql 1
