'use strict'

###*
# @fileOverview Tests about databaseStructure exports
###

# require packages
databaseStructureClasses = require '../../../lib/databaseStructure.js'
should = require 'should'

describe 'Database structure classes export', ->

    it 'should exports all database structure classes', ->
        databaseStructureClasses.should.have.keys [
            'Table'
            'ComplexType'
            'SimpleType'
        ]
