'use strict'

###*
# @fileOverview Tests about database structure Relation class
###

# require packages
clone = require 'clone'
mocks = require '../../_mocks.js'
Relation = require '../../../../lib/databaseStructure/Relation.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null

describe 'Database structure : Relation class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        done()

    it 'should create new relation', ->
        val = new Relation(mocksUtils.dbStructureRelation)
        val.should.be.instanceof Relation
        val.should.have.keys [
            'originColumn'
            'destTable'
            'destColumn'
            'isInverse'
        ]
