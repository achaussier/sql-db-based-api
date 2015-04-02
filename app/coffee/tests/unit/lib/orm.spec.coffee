'use strict'

###*
# @fileOverview Unit tests for orm lib
###

###*
# Required custom classes
###
DatabaseStructure             = require '../../../lib/class/DatabaseStructure.js'
GenericGetStructureConstraint = require '../../../lib/class/GenericGetStructureConstraint'
GenericGetStructureOptions    = require '../../../lib/class/GenericGetStructureOptions.js'

###*
# Required modules
###
clone       = require 'clone'
mocks       = require '../_mocks.js'
ormUtils    = require '../../../lib/orm.js'
sinon       = require 'sinon'
should      = require 'should'

###*
# Declare variables
###
dbStructure             = undefined
getStructureConstraint  = undefined
mocksUtils              = undefined
stub                    = undefined
val                     = undefined

describe 'ORM lib', ->

    beforeEach (done) ->
        constraint      = null
        dbStructure     = new DatabaseStructure()
        mocksUtils      = clone mocks
        stub            = null
        done()

    describe 'isGenericGetStructureConstraint', ->

        ###*
        # Check with null object
        ###
        it 'should return false', ->
            val = ormUtils.isGenericGetStructureConstraint null
            val.should.be.false

        ###*
        # Check with bad object
        ###
        it 'should return false', ->
            val = ormUtils.isGenericGetStructureConstraint {}
            val.should.be.false

        ###*
        # Check with null object
        ###
        it 'should return true', ->
            stub = sinon.stub(
                dbStructure,
                'checkPath',
                ->
                    true
            )

            getStructureConstraint = new GenericGetStructureConstraint(
                'foo',
                mocksUtils.GenericGetStructureConstraint,
                dbStructure
            )
            val         = ormUtils.isGenericGetStructureConstraint getStructureConstraint
            val.should.be.true

    describe 'isGenericGetStructureOptions', ->

        ###*
        # Check with null object
        ###
        it 'should return false', ->
            val = ormUtils.isGenericGetStructureOptions null
            val.should.be.false

        ###*
        # Check with bad object
        ###
        it 'should return false', ->
            val = ormUtils.isGenericGetStructureOptions {}
            val.should.be.false

        ###*
        # Check with null object
        ###
        it 'should return true', ->
            val = ormUtils.isGenericGetStructureOptions(new GenericGetStructureOptions())
            val.should.be.true
