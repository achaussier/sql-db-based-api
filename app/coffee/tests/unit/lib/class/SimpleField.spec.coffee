'use strict'

###*
# @fileOverview Tests about database structure SimpleField class
###

###*
# Required custom classes
###
Field       = require '../../../../lib/class/Field.js'
SimpleField = require '../../../../lib/class/SimpleField.js'

###*
# Required modules
###
clone   = require 'clone'
mocks   = require '../../_mocks.js'
should  = require 'should'

###*
# Decalre variablesS
###
mocksUtils  = undefined
field       = undefined
simpleField = undefined

describe 'Database structure : SimpleField class', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        field       = null
        simpleField = null
        done()

    ###*
    # A new field instanceof
    ###
    it 'should create new simple field', ->
        field       = new Field(mocksUtils.dbStructureField)
        simpleField = new SimpleField(field)
        simpleField.should.be.instanceof SimpleField
        simpleField.should.have.keys [
            'criticality'
            'type'
            'isNullable'
            'isViewable'
            'maxLength'
            'defaultValue'
            'isAutoIncrement'
        ]
