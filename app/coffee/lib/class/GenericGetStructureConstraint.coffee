'use strict'

###*
# @fileOverview This file contains the GenericGetStructureConstraint class
# @class GenericGetStructureConstraint
###

isArray = require('util').isArray

containsErrorValue  = require('../global.js').containsErrorValue
DatabaseStructure   = require './DatabaseStructure.js'
isNotEmptyString    = require('../global.js').isNotEmptyString

class GenericGetStructureConstraint

    ###*
    # Constructor of GenericGetStructureConstraint class
    # @constructor
    # @param    {String}    objectType          Type of object requested
    # @param    {Object}    databaseStructure   App database structure
    # @return   {Object}
    ###
    constructor: (obj) ->
        ###*
        # Execute parameters check
        ###
        checks =
            obj: isNotEmptyString(obj)

        ###*
        # Check if errors occured during checks
        ###
        checkErrors = containsErrorValue checks

        if checkErrors.length isnt 0
            return checkErrors

        @obj = obj

module.exports = GenericGetStructureConstraint
