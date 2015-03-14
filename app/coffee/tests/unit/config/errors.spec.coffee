'use strict'

###*
# @fileOverview Test about error config file
###

# require packages
should = require 'should'
rmErrors = require '../../../lib/errors.js'
configObj = require '../../../config/errors.js'

# declare variables
val = undefined

###*
# ParameterError returned when error call
# @type {Array}
###
parameterErrors = [
    'invalidParams'
    'missingParams'
]

describe 'Config : errors', ->

    beforeEach (done) ->
        errVal = undefined
        errName = undefined
        errors = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'errors'
        done()

    for key, value of configObj
        val = configObj[key].errors({})

        for own errName, errVal of val
            do (errName, errVal) ->
                if typeof errVal is 'function'

                    if parameterErrors.indexOf(errName) isnt -1
                        ###*
                        # This error call should return a ParameterError array
                        ###
                        it 'should return array of ParameterError if ' + errName + ' error', ->
                            errors = errVal(['foo'])
                            errors.should.be.instanceof Array
                            errors[0].should.be.instanceof rmErrors.ParameterError

                    else
                        ###
                        # Else, it's a simple error string
                        ###
                        it 'should return error string if ' + errName + ' error', ->
                            errVal(['foo']).should.be.instanceof String
