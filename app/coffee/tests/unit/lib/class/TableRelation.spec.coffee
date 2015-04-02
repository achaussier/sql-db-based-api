'use strict'

###*
# @fileOverview Tests about database structure TableRelation class
###

###*
# Required custom classes
###
TableRelation = require '../../../../lib/class/TableRelation.js'

###*
# Required modules
###
should = require 'should'

###*
# Declare variables
###
tableRelation = undefined

describe 'Database structure : TableRelation class', ->

    beforeEach (done) ->
        tableRelation = new TableRelation('foo')
        done()

    ###*
    # Check if instance is create
    ###
    it 'should create new TableRelation', ->
        tableRelation.should.be.instanceof TableRelation
        tableRelation.should.have.keys [
            'name'
            'relations'
            'inverseRelations'
        ]

    ###*
    # Check add a relation
    ###
    it 'should possible to push relation', ->
        tableRelation.relations.length.should.be.eql 0
        tableRelation.addRelation { foo: 'bar' }
        tableRelation.relations.length.should.be.eql 1

    ###*
    # Check add an inverse relation
    ###
    it 'should possible to push inverse relation', ->
        tableRelation.inverseRelations.length.should.be.eql 0
        tableRelation.addInverseRelation { foo: 'bar' }
        tableRelation.inverseRelations.length.should.be.eql 1
