'use strict'

###*
# @fileOverview This file contains functions used for query building
###

clone               = require 'clone'
containsErrorValue  = require('./global.js').containsErrorValue
isArray             = require('util').isArray
isNotEmptyString    = require('./global.js').isNotEmptyString
isStringArray       = require('../global.js').isStringArray
Q                   = require 'q'
rmErrors            = require './errors.js'


###*
# Sort a select array by depth
# @param    {Array}     selectArray     Contains all path requested
# @return   {Array}                     Select array sorted by depth
# @throw                                ParameterError if bad parameter
###
sortSelectByDepth = (selectArray) ->
    ###*
    # Clone select array to keep original array intact
    ###
    orderedSelect = clone selectArray

    ###*
    # Check param and if it's ok, sort clone array and return it
    ###
    if not isStringArray(selectArray)
        Q.fcall ->
            throw new rmErrors.ParameterError(
                'selectArray',
                'string-array',
                selectArray
            )
    else
        orderedSelect.sort (a, b) ->
            return (a.split('.').length - 1) - (b.split('.').length - 1)

        Q.fcall ->
            orderedSelect

exports.sortSelectByDepth = sortSelectByDepth

