'use strict'

###*
# @fileOverview This file contains the GenericGetStructureOrder class
# @class GenericGetStructureOrder
###

###*
# Require custom classes
###
apiErrors = require '../errors.js'

###*
# Require custom classes
###
containsErrorValue  = require('../global.js').containsErrorValue
isArray             = require('util').isArray
isNotEmptyString    = require('../global.js').isNotEmptyString

###*
# Require custom classes
###
DatabaseStructure   = require './DatabaseStructure.js'

class GenericGetStructureOrder

    ###*
    # Constructor of GenericGetStructureOrder class
    # @constructor
    # @param    {String}    objectType          Type of object requested
    # @param    {String}    field               Field used to order
    # @param    {String}    asc                 Order sorting
    # @param    {Object}    databaseStructure   App database structure
    # @return   {Object}                        Order instance
    # @throw    {Object}                        ParameterError if bad param
    ###
    constructor: (objectType, field, asc, dbStructure) ->
        ###*
        # Execute parameters check
        ###
        errors = @checkConstructorParams(objectType, field, asc, dbStructure)

        if errors.length isnt 0
            return errors
        else
            @field  = field
            @asc    = asc

    ###*
    # Check constructor params
    # @param    {String}    objectType          Type of object requested
    # @param    {String}    field               Field used to order
    # @param    {String}    asc                 Order sorting
    # @param    {Object}    databaseStructure   App database structure
    # @return   {Object}                        Order instance
    # @throw    {Object}                        ParameterError if bad param
    ###
    checkConstructorParams: (objectType, field, asc, dbStructure) ->
        errors = []
        ###*
        # Check if params are valid
        ###
        if not isNotEmptyString(objectType)
            errors.push new apiErrors.ParameterError(
                'objectType',
                'string'
                objectType
            )
        else if not (dbStructure instanceof DatabaseStructure)
            errors.push new apiErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure'
                dbStructure
            )
        else if not dbStructure.checkPath(field, objectType)
            errors.push new apiErrors.ParameterError(
                'field',
                'string'
                field
            )
        else if not (asc is 'asc') and not (asc is 'desc')
            errors.push new apiErrors.ParameterError(
                'asc',
                'string'
                asc
            )
        errors

module.exports = GenericGetStructureOrder
