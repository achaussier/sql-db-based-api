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

###*
# Validate if param is a not empty string
# @param {String} element Element to test
# @return {Boolean} True if element is a not empty string, else false
###
isNotEmptyString = (element) ->

    if not element? or typeof element isnt 'string' or element is ''
        false
    else
        true

exports.isNotEmptyString = isNotEmptyString

###*
# Check if values are same in these arrays
# @param {Array} a Source array
# @param {Array} b Array to compare
# @return {Boolean} True if arrays have same values
# @note This method does not work with Object if references are differents !
# @note Take from http://stackoverflow.com/questions/11142666
# @todo Complete the function to avoid the note problem
###
areSameArrays = (a, b) ->
    if isArray(a) and isArray(b)
        a.length is b.length and a.every (elem, i) -> elem is b[i]
    else
        false

exports.areSameArrays = areSameArrays
