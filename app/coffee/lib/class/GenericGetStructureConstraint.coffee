'use strict'

###*
# @fileOverview This file contains the GenericGetStructureConstraint class
# @class GenericGetStructureConstraint
###

isArray = require('util').isArray

containsErrorValue  = require('../global.js').containsErrorValue
DatabaseStructure   = require './DatabaseStructure.js'
isNotEmptyString    = require('../global.js').isNotEmptyString
apiErrors           = require('../errors.js')

class GenericGetStructureConstraint

    ###*
    # Constructor of GenericGetStructureConstraint class
    # @constructor
    # @param    {String}    objectType          Type of object requested
    # @param    {Object}    constraintData      Data used to build a constraint
    # @param    {Object}    dbStructure         App database structure
    # @return   {Object}
    # @example
    # Structure of constraintData param :
    # Keys :
    #   - type      : Type of constraint : 'field'
    #   - field     : Path of field (dot splitted)
    #   - link      : Link to another constraint : 'and', 'or', null
    #   - value     : Value to use
    #   - operator  : Operator to use
    # Json :
    # {
    #   type    : <String>,
    #   field   : <String>,
    #   link    : <String|null>,
    #   value   : <String|Number|Array>,
    #   operator: <String>
    # }
    ###
    constructor: (objectType, constraintData, dbStructure) ->
        ###*
        # Execute parameters check
        ###
        checks =
            field   : dbStructure?.checkPath(constraintData?.field, objectType)
            main    : @checkOperatorAndValue(
                constraintData?.operator,
                constraintData?.type,
                constraintData?.value
            )
            link    : @checkLink(constraintData?.link)

        ###*
        # Check dbStructure param and if errors occured during checks
        ###
        checkErrors = containsErrorValue checks

        if not (dbStructure instanceof DatabaseStructure)
            return new apiErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure',
                dbStructure
            )
        else if checkErrors.length isnt 0
            return checkErrors

        ###*
        # If no errors, build object
        ###
        @constraints    = []
        @field          = constraintData.field.toLowerCase()
        @link           = constraintData.link?.toLowerCase() or null
        @operator       = constraintData.operator.toLowerCase()
        @type           = constraintData.type.toLowerCase()
        @value          = constraintData.value

    ###*
    # Check link key
    # @param    {String}    link    Link value to check
    # @return   {Boolean}           True if link contains a valid value
    # @throw    {Object}            ParameterError if incorect value
    ###
    checkLink: (link) ->
        linkToTest  = link?.toLowerCase()
        if not link? or (linkToTest is 'and') or (linkToTest is 'or')
            return true
        return new apiErrors.ParameterError(
            'link',
            'string',
            link
        )

    ###*
    # Check constraint for a number value
    # @param    {String}    operator    Operator sent
    # @param    {String}    type        Constraint type
    # @param    {*}         value       Value sent
    # @return   {Boolean}               True if valid set of param
    # @throw                            ParameterError if invalid
    ###
    checkNumberValueConstraint: (operator, type, value) ->
        ###*
        # Build an error object to used if error
        ###
        errorObj = new apiErrors.ParameterError(
            'check-constraint',
            'valid-params',
            {
                operator: operator
                type    : type
                value   : value
            }
        )

        if type is 'field'
            if not @checkOperatorFieldNumberValue(operator)
                errorObj.message = 'invalid-operator-for-this-constraint'
                return errorObj
            return true

        ###*
        # Other type cannot use number in value
        ###
        errorObj.message = 'invalid-operator-for-this-constraint'
        return errorObj

    ###*
    # Check constraint for an string value
    # @param    {String}    operator    Operator sent
    # @param    {String}    type        Constraint type
    # @param    {*}         value       Value sent
    # @return   {Boolean}               True if valid set of param
    # @throw                            ParameterError if invalid
    ###
    checkStringValueConstraint: (operator, type, value) ->
        ###*
        # Build an error object to used if error
        ###
        errorObj = new apiErrors.ParameterError(
            'check-constraint',
            'valid-params',
            {
                operator: operator
                type    : type
                value   : value
            }
        )

        if type is 'field'
            if not @checkOperatorFieldStringValue(operator)
                errorObj.message = 'invalid-operator-for-this-constraint'
                return errorObj
            return true

        ###*
        # Other type cannot use string in value
        ###
        errorObj.message = 'invalid-operator-for-this-constraint'
        return errorObj

    ###*
    # Check constraint for an array value
    # @param    {String}    operator    Operator sent
    # @param    {String}    type        Constraint type
    # @param    {*}         value       Value sent
    # @return   {Boolean}               True if valid set of param
    # @throw                            ParameterError if invalid
    ###
    checkArrayValueConstraint: (operator, type, value) ->
        ###*
        # Build an error object to used if error
        ###
        errorObj = new apiErrors.ParameterError(
            'check-constraint',
            'valid-params',
            {
                operator: operator
                type    : type
                value   : value
            }
        )

        ###*
        # Empty array is not a possible value
        ###
        if value.length is 0
            errorObj.message = 'empty-array-is-invalid-value'
            return errorObj

        else if type is 'field'
            ###*
            # If type is field, operator should be 'in', 'not in', between
            ###
            if not @checkOperatorFieldArrayValue(operator)
                errorObj.message = 'invalid-operator-for-this-constraint'
                return errorObj
            else if (operator is 'between') and (value.length isnt 2)
                errorObj.message = 'invalid-value-for-between-operator'
                return errorObj
            return true

        ###*
        # Other type cannot use array in value
        ###
        errorObj.message = 'invalid-operator-for-this-constraint'
        return errorObj

    ###*
    # Check if operator is valid for a type field and an array value
    # @param    {String}    operator    Operator to test
    # @return   {Boolean}               True if operator is valid
    # @throw                            ParameterError if invalid operator
    ###
    checkOperatorFieldArrayValue: (operator) ->
        availableOperators = [
            'between'
            'in'
            'not in'
        ]
        availableOperators.indexOf(operator) isnt -1

    ###*
    # Check if operator is valid for a type field and a string value
    # @param    {String}    operator    Operator to test
    # @return   {Boolean}               True if operator is valid
    # @throw                            ParameterError if invalid operator
    ###
    checkOperatorFieldStringValue: (operator) ->
        availableOperators = [
            '='
            '!='
            'like'
            'not like'
        ]
        availableOperators.indexOf(operator) isnt -1

    ###*
    # Check if operator is valid for a type field and a string value
    # @param    {String}    operator    Operator to test
    # @return   {Boolean}               True if operator is valid
    # @throw                            ParameterError if invalid operator
    ###
    checkOperatorFieldNumberValue: (operator) ->
        availableOperators = [
            '>'
            '>='
            '<'
            '<='
            '='
            '!='
            'like'
            'not like'
        ]
        availableOperators.indexOf(operator) isnt -1

    ###*
    # Check if operator is valid for the value type and type of constraint
    # @param    {String}    operator    Operator sent
    # @param    {String}    type        Constraint type
    # @param    {*}         value       Value sent
    # @return   {Boolean}               True if valid set of param
    # @throw                            ParameterError if invalid
    ###
    checkOperatorAndValue: (operator, type, value) ->
        ###*
        # If value is an array
        ###
        if isArray(value)
            return @checkArrayValueConstraint(operator, type, value)

        else if typeof value is 'string'
            ###*
            # Check operator used with string value
            ###
            return @checkStringValueConstraint(operator, type, value)

        else if not isNaN(Number(value))
            ###*
            # Check operator for number value
            ###
            return @checkNumberValueConstraint(operator, type, value)

        else
            ###*
            # Invalid value type
            ###
            return new apiErrors.ParameterError(
                'check-constraint',
                'valid-params',
                {
                    operator: operator
                    type    : type
                    value   : value
                },
                'value-type-not-managed'
        )

module.exports = GenericGetStructureConstraint
