'use strict'

###*
# @fileOverview This file contains the GenericGetStructureMain class
# @class GenericGetStructureMain
###

containsErrorValue  = require('../global.js').containsErrorValue
isArray             = require('util').isArray
isNotEmptyString    = require('../global.js').isNotEmptyString
isStringArray       = require('../global.js').isStringArray
Q                   = require 'q'
rmErrors            = require '../errors.js'

GenericGetStructureConstraint   = require './GenericGetStructureConstraint.js'
DatabaseStructure               = require './DatabaseStructure.js'
GenericGetStructureOptions      = require './GenericGetStructureOptions.js'


class GenericGetStructureMain

    ###*
    # Constructor of GenericGetStructureMain class
    # @constructor
    # @param    {String}    objectType    Type of object requested
    # @param    {Object}    dbStructure   App database structure
    # @return   {Object}
    ###
    constructor: (objectType, dbStructure) ->
        ###*
        # Execute parameters check
        ###
        checks =
            objectType: @checkReturnType objectType, dbStructure

        ###*
        # Check if errors occured during checks
        ###
        checkErrors = containsErrorValue checks

        @select         = []
        @constraints    = []
        @options        = {}

        if checkErrors.length isnt 0
            return checkErrors

        @returnType = objectType

    ###*
    # check returnType attribute and dbStructure
    # @param    {Array}     newSelect     List of fields to require
    # @param    {Object}    dbStructure   Database structure
    # @return   {Boolean}                 True if select succesfully set
    # @throw    {Object}                  ParameterError if bad param
    ###
    checkReturnType: (objectType, dbStructure) ->
        ###*
        # Check if objectType and dbStructure params are valid
        ###
        if not isNotEmptyString objectType
            new rmErrors.ParameterError(
                'objectType',
                'string'
                objectType
            )
        else if not (dbStructure instanceof DatabaseStructure)
            new rmErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure'
                dbStructure
            )
        else if not dbStructure.containsTable objectType
            ###*
            # Check if objectType and dbStructure params are valid
            ###
            new rmErrors.ParameterError(
                'objectType',
                'existing-table'
                objectType
            )


    ###*
    # Set an array to select attribute
    # @param    {Array}     newSelect     List of fields to require
    # @param    {Object}    dbStructure   Database structure
    # @return   {Boolean}                 True if select succesfully set
    # @throw    {Object}                  ParameterError if bad param
    ###
    setSelect: (newSelect, dbStructure) ->
        ###*
        # Check if newSelect param is valid
        ###
        if not isArray(newSelect) or not isStringArray(newSelect)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'newSelect',
                    'string-array'
                    newSelect
                )
        else if not (dbStructure instanceof DatabaseStructure)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'dbStructure',
                    'DatabaseStructure'
                    dbStructure
                )
        else
            ###*
            # Check if each path is valid
            ###
            errors = []
            for path in newSelect
                if not dbStructure.checkPath(path, @returnType)
                    errorObj = new rmErrors.ParameterError(
                        'path',
                        'string'
                        path,
                        'invalid-path-defined-in-select'
                    )
                    errors.push errorObj

            if errors.length isnt 0
                Q.fcall ->
                    throw errors
            else
                @select = newSelect
                Q.fcall ->
                    true

    ###*
    # Add a path to select attribute
    # @param    {String}    path          A valid field path
    # @param    {Object}    dbStructure   Database structure
    # @return   {Boolean}                 True if path succesfully add
    # @throw    {Object}                  ParameterError if bad param
    ###
    addSelect: (path, dbStructure) ->
        ###*
        # Check if params are valid
        ###
        if not isNotEmptyString path
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'path',
                    'string'
                    path
                )
        else if not (dbStructure instanceof DatabaseStructure)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'dbStructure',
                    'DatabaseStructure'
                    dbStructure
                )
        else if not dbStructure.checkPath(path, @returnType) or not @containsPath(path)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'path',
                    'string'
                    path
                )
        else
            @select.push path
            Q.fcall ->
                true

    ###*
    # Set an GenericGetStructureOptions object to options attribute
    # @param    {Object}    optionsObj  A GenericGetStructureOptions instance
    # @return   {Boolean}               True if options succesfully set
    # @throw    {Object}                ParameterError if bad param
    ###
    setOptions: (optionsObj) ->
        ###*
        # Check if optionsObj param is valid
        ###
        if not optionsObj? or not (optionsObj instanceof GenericGetStructureOptions)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'optionsObj',
                    'GenericGetStructureOptions'
                    optionsObj
                )
        else
            @options = optionsObj
            Q.fcall ->
                true

    ###*
    # Set an array to constraints attribute
    # @param    {Array}     newConstraints  List of fields to require
    # @return   {Boolean}                   True if constraints succesfully set
    # @throw    {Object}                    ParameterError if bad param
    ###
    setConstraints: (newConstraints) ->
        ###*
        # Check if newConstraints param is valid
        ###
        if not @isConstraintArray newConstraints
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'newConstraints',
                    'GenericGetStructureConstraint-array'
                    newConstraints
                )
        else
            @constraints = newConstraints
            Q.fcall ->
                true

    ###*
    # Add a constraint to constraints attribute
    # @param    {Object}     constraint Constraint to add
    # @return   {Boolean}               True if constraint succesfully add
    # @throw    {Object}                ParameterError if bad param
    ###
    addConstraint: (constraint) ->
        ###*
        # Check if constraint param is valid
        ###
        if not constraint? or not (constraint instanceof GenericGetStructureConstraint)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'constraint',
                    'GenericGetStructureConstraint'
                    constraint
                )
        else
            @constraints.push constraint
            Q.fcall ->
                true

    ###*
    # Check if a path exists in select array
    # @param    {String}    path    Path to search
    # @return   {Boolean}           True if path exists, else false
    # @throw    {Object}            ParameterError if bad param
    ###
    containsPath: (path) ->
        @select.indexOf path isnt -1

    ###*
    # Check if array param contains only GenericGetStructureConstraint objects
    # @param    {Array}     constraints     Array to check
    # @return   {Boolean}                   True if contains only constraint
    # @throw    {Object}                    ParameterError if bad param
    ###
    isConstraintArray: (constraints) ->
        ###*
        # Check if constraints param is valid
        ###
        if not isArray constraints
            return false
        ###*
        # Check array content
        ###
        validContent = true
        for constraint in constraints
            if not (constraint instanceof GenericGetStructureConstraint)
                validContent = false
        validContent

module.exports = GenericGetStructureMain
