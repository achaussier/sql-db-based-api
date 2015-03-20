'use strict'

###*
# @fileOverview Tests about database structure ComplexField class
###

# require packages
ComplexField = require '../../../../lib/class/ComplexField.js'
clone = require 'clone'
Field = require '../../../../lib/class/Field.js'
mocks = require '../../_mocks.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null
val2 = null

describe 'Database structure : ComplexField class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        val2 = null
        done()

    it 'should create new complex field', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val2 = new ComplexField(val)
        val2.should.be.instanceof ComplexField
        val2.should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]
