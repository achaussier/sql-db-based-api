'use strict'

###*
# @fileOverview Tests about database structure Relation class
###

# require packages
Relation = require '../../../../lib/databaseStructure/Relation.js'
should = require 'should'

errorObj = null
val = null

describe 'Database structure : Relation class', ->

    beforeEach (done) ->
        errorObj = null
        vall = null
        done()

    it 'should create new relation', ->
        val = new Relation('foo', 'bar', 'foobar')
        val.should.be.instanceof Relation
        val.should.have.keys [
            'originColumn'
            'destTable'
            'destColumn'
        ]
