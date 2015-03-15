'use strict'

###*
# @fileOverview Tests about database structure SimpleField class
###

# require packages
SimpleField = require '../../../../lib/databaseStructure/SimpleField.js'
should = require 'should'

errorObj = null
val = null

describe 'Database structure : SimpleField class', ->

    beforeEach (done) ->
        errorObj = null
        val = null
        done()

    it 'should create new simple field', ->
        val = new SimpleField('foo')
        val.should.be.instanceof SimpleField
        val.should.have.keys [
            'name'
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'maxLength'
            'defaultValue'
            'isAutoIncrement'
        ]
