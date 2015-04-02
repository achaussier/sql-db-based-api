'use strict'

###*
# @fileOverview Function can be used in others lib
###

Q           = require 'q'
isArray     = require('util').isArray
apiErrors   = require './errors.js'

###*
# Validate if all keys exists and have not null value in this object
# @param {Object} obj Object to test
# @param {Array} keys Keys to test
# @return {Object} Return object if all keys exists
# @throw {Object} ParameterError is incorrect params sent or error keys
###
checkKeysHaveNotNullValues = (obj, keys) ->

    result      = true
    errorObj    = null

    ###*
    # Check parameters
    ###
    if not obj? or typeof obj is not 'object'
        Q.fcall ->
            throw new apiErrors.ParameterError(
                'obj',
                'Object',
                obj
            )
    else if not keys? or not isArray(keys)
        Q.fcall ->
            throw new apiErrors.ParameterError(
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

        if result
            Q.fcall ->
                obj
        else
            Q.fcall ->
                throw new apiErrors.ParameterError(
                    'keys',
                    keys,
                    obj,
                    'missing-mandatory-values-for-object'
                )

exports.checkKeysHaveNotNullValues = checkKeysHaveNotNullValues

###*
# Validate if all keys exists and have not null value in this object
# @param {Object} obj Object to test
# @param {Array} keys Keys to test
# @return {Object} Return object if all keys exists
# @throw {Object} ParameterError is incorrect params sent or error keys
###
checkKeys = (obj, keys) ->

    result      = true
    errorObj    = null

    ###*
    # Check parameters
    ###
    if not obj? or typeof obj is not 'object'
        Q.fcall ->
            throw new apiErrors.ParameterError(
                'obj',
                'Object',
                obj
            )
    else if not keys? or not isArray(keys)
        Q.fcall ->
            throw new apiErrors.ParameterError(
                'keys',
                'Array',
                keys
            )

    else
        ###*
        # Parameters are valid, check if keys exists
        ###
        for key in keys
            do ->
                if not obj.hasOwnProperty(key)
                    result = false

        if result
            Q.fcall ->
                obj
        else
            Q.fcall ->
                throw new apiErrors.ParameterError(
                    'keys',
                    keys,
                    obj,
                    'bad-keys-for-object'
                )

exports.checkKeys = checkKeys

###*
# Validate if param is a not empty string
# @param {String} element Element to test
# @return {Boolean} True if element is a not empty string, else false
###
isNotEmptyString = (element) ->

    element? and typeof element is 'string' and element isnt ''

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

###*
# Check if object contains errors values (one level check)
# @param    {Object}    obj Source array
# @return   {Boolean}       True if error found in values, else false
###
containsErrorValue = (obj) ->
    errors = []

    for key, value of obj
        if apiErrors.isJsError(value) or apiErrors.isCustomError(value)
            errors.push value
    errors

exports.containsErrorValue = containsErrorValue

###*
# Check if contains only string
# @param    {Array}    arrayToTest  Source array
# @return   {Boolean}               True if array contains only strings
###
isStringArray = (arrayToTest) ->
    onlyString = true

    if not arrayToTest? or not isArray(arrayToTest)
        return false

    for value in arrayToTest
        do (value) ->
            if typeof value isnt 'string'
                onlyString = false

    onlyString

exports.isStringArray = isStringArray
