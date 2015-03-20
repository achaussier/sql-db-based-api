'use strict'

###*
# @fileOverview Tests about database structure SimpleField class
###

# require packages
clone = require 'clone'
Field = require '../../../../lib/class/Field.js'
mocks = require '../../_mocks.js'
SimpleField = require '../../../../lib/class/SimpleField.js'
should = require 'should'

errorObj = null
mocksUtils = null
val = null
val2 = null

describe 'Database structure : SimpleField class', ->

    beforeEach (done) ->
        errorObj = null
        mocksUtils = clone mocks
        val = null
        val2 = null
        done()

    it 'should create new simple field', ->
        val = new Field(mocksUtils.dbStructureField)
        val.should.be.instanceof Field
        val2 = new SimpleField(val)
        val2.should.be.instanceof SimpleField
        val2.should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'maxLength'
            'defaultValue'
            'isAutoIncrement'
        ]
