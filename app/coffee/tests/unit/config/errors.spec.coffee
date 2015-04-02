'use strict'

###*
# @fileOverview Test about error config file
###

###*
# Require modules
###
apiErrors   = require '../../../lib/errors.js'
configObj   = require '../../../config/errors.js'
should      = require 'should'

###*
# Declare variables
###
errName = undefined
errors  = undefined
errVal  = undefined
val     = undefined

###*
# ParameterError returned when error call
# @type {Array}
###
parameterErrors = [
    'invalidParams'
    'missingParams'
]

###*
# ServerError returned when error call
# @type {Array}
###
serverErrors = [
    'serverErrorMessage'
    'serverShuttingDown'
    'tooManyPendingActions'
    'unknownAction'
    'unsupportedServerType'
    'doubleCallbackError'
    'fileNotFound'
    'fileNotProvided'
    'fileInvalidPath'
    'fileReadError'
]

describe 'Config : errors', ->

    beforeEach (done) ->
        errName = null
        errors  = null
        errVal  = null
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
                            errors[0].should.be.instanceof apiErrors.ParameterError

                    else if serverErrors.indexOf(errName) isnt -1
                        ###*
                        # This error call should return a ServerError array
                        ###
                        it 'should return array of ServerError if ' + errName + ' error', ->
                            errors = errVal(['foo'])
                            errors.should.be.instanceof Array
                            errors[0].should.be.instanceof apiErrors.ServerError

                    else
                        ###*
                        # Else, it's a simple error string
                        ###
                        it 'should return error string if ' + errName + ' error', ->
                            errVal(['foo']).should.be.instanceof String
