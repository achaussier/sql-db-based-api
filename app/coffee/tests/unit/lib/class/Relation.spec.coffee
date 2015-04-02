'use strict'

###*
# @fileOverview Tests about database structure Relation class
###

###*
# Require custom classes
###
Relation = require '../../../../lib/class/Relation.js'

###*
# Require modules
###
clone   = require 'clone'
mocks   = require '../../_mocks.js'
should  = require 'should'

###*
# Declare variables
###
errorObj    = null
mocksUtils  = null
relation    = null

describe 'Database structure : Relation class', ->

    beforeEach (done) ->
        errorObj    = null
        mocksUtils  = clone mocks
        relation    = null
        done()

    ###
    # Create new instance of this object
    ###
    it 'should create new relation', ->
        relation = new Relation(mocksUtils.dbStructureRelation)
        relation.should.be.instanceof Relation
        relation.should.have.keys [
            'originColumn'
            'destTable'
            'destColumn'
            'isInverse'
        ]
