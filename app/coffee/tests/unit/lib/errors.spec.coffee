'use strict'

###*
# @fileOverview Tests about errors exports
###

# require packages
errorClasses = require '../../../lib/errors.js'
should = require 'should'

describe 'Custom error classes export', ->

    it 'should exports all custom error classes', ->
        errorClasses.should.have.keys [
            'DatabaseError'
            'ParameterError'
            'ServerError'
        ]
