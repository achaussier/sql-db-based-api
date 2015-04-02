'use strict'

###*
# @fileOverview Tests about database structure ComplexField class
###

###
# Required modules
###
ComplexField = require '../../../../lib/class/ComplexField.js'
clone = require 'clone'
Field = require '../../../../lib/class/Field.js'
mocks = require '../../_mocks.js'
should = require 'should'

###*
# Declare variables
###
complexField    = undefined
field           = undefined
mocksUtils      = undefined


describe 'Database structure : ComplexField class', ->

    beforeEach (done) ->
        complexField    = null
        field           = field
        mocksUtils      = clone mocks
        done()

    ###
    # Check with valid field
    ###
    it 'should create new complex field', ->
        field = new Field(mocksUtils.dbStructureField)
        field.should.be.instanceof Field
        complexField = new ComplexField(field)
        complexField.should.be.instanceof ComplexField
        complexField.should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]
