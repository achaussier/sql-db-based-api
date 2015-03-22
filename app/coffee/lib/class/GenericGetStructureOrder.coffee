'use strict'

###*
# @fileOverview This file contains the GenericGetStructureOrder class
# @class GenericGetStructureOrder
###

isArray = require('util').isArray

containsErrorValue  = require('../global.js').containsErrorValue
DatabaseStructure   = require './DatabaseStructure.js'
isNotEmptyString    = require('../global.js').isNotEmptyString
rmErrors            = require '../errors.js'

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
            errors.push new rmErrors.ParameterError(
                'objectType',
                'string'
                objectType
            )
        else if not (dbStructure instanceof DatabaseStructure)
            errors.push new rmErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure'
                dbStructure
            )
        else if not dbStructure.checkPath(field, objectType)
            errors.push new rmErrors.ParameterError(
                'field',
                'string'
                field
            )
        else if not (asc is 'asc') and not (asc is 'desc') and asc?
            errors.push new rmErrors.ParameterError(
                'asc',
                'string'
                asc
            )
        errors

module.exports = GenericGetStructureOrder
