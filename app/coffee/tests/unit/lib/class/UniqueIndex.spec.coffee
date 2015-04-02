'use strict'

###*
# @fileOverview Tests about database structure UniqueIndex class
###

###*
# Required custom classes
###
UniqueIndex = require '../../../../lib/class/UniqueIndex.js'

###*
# Required modules
###
clone   = require 'clone'
mocks   = require '../../_mocks.js'
should  = require 'should'

###*
# Declare variable
###
mocksUtils  = undefined
index       = undefined

describe 'Database structure : UniqueIndex class', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        index       = new UniqueIndex(mocksUtils.dbStructureUniqueIndex)
        done()

    ###*
    # Check instance create
    ###
    it 'should create new UniqueIndex', ->
        index.should.be.instanceof UniqueIndex
        index.should.have.keys [
            'columns'
            'name'
            'tableName'
        ]

    ###*
    # Check adding a column twice
    ###
    it 'should not be possible to add same column', ->
        index.addColumn('foobar').should.be.false
        index.columns.length.should.be.eql 1

    ###*
    # Check adding a new column
    ###
    it 'should be possible to add another column', ->
        index.addColumn('foobar2').should.be.true
        index.columns.length.should.be.eql 2
