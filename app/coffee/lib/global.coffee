'use strict'

###*
# @fileOverview Function can be used in others lib
###

Q = require 'q'
isArray = require('util').isArray
rmErrors = require './errors.js'

###*
# Validate if all keys exists and have not null value in this object
# @param {Object} obj Object to test
# @param {Array} keys Keys to test
# @return {Boolean} True if all keys exists, else false
# @throw {Object} ParameterError is incorrect params sent
###
checkKeysHaveNotNullValues = (obj, keys) ->

    result = true
    errorObj = null

    ###*
    # Check parameters
    ###
    if not obj? or typeof obj is not 'object'
        Q.fcall ->
            throw new rmErrors.ParameterError(
                'obj',
                'Object',
                obj
            )
    else if not keys? or not isArray(keys)
        Q.fcall ->
            throw new rmErrors.ParameterError(
                'keys',
                'Array',
                keys
            )

    else
        ###*
        # Parameters are valid, check if keys exists and have not null value
        ###
        for key in keys
            do ->
                if not key? or not obj[key]?
                    result = false

        Q.fcall ->
            result

exports.checkKeysHaveNotNullValues = checkKeysHaveNotNullValues
