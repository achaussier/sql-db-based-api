'use strict'

###*
# @fileOverview Tests about database structure ComplexField class
###

# require packages
ComplexField = require '../../../../lib/databaseStructure/ComplexField.js'
should = require 'should'

errorObj = null
val = null

describe 'Database structure : ComplexField class', ->

    beforeEach (done) ->
        errorObj = null
        val = null
        done()

    it 'should create new complex field', ->
        val = new ComplexField('foo')
        val.should.be.instanceof ComplexField
        val.should.have.keys [
            'name'
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'isArray'
        ]
