'use strict'

###*
# @fileOverview This file contains functions used for query building
###

clone               = require 'clone'
containsErrorValue  = require('./global.js').containsErrorValue
DatabaseStructure   = require './class/DatabaseStructure.js'
Field               = require './class/Field.js'
isArray             = require('util').isArray
isNotEmptyString    = require('./global.js').isNotEmptyString
isStringArray       = require('./global.js').isStringArray
Q                   = require 'q'
Relation            = require './class/Relation.js'
rmErrors            = require './errors.js'
Table               = require './class/Table.js'


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
            return (b.split('.').length - 1) - (a.split('.').length - 1)

        Q.fcall ->
            orderedSelect

exports.sortSelectByDepth = sortSelectByDepth

###*
# Generate INNER JOIN for a required foreign key
# @param    {Object}    table       Source table object
# @param    {Object}    field       Source field object
# @return   {String}                An inner join part
###
buildInnerJoin = (table, field) ->
    ###*
    # Check params and process inner join build if ok
    ###
    if not (table instanceof Table)
        return new rmErrors.ParameterError(
            'table',
            'Table',
            table
        )
    else if not (field instanceof Field)
        return new rmErrors.ParameterError(
            'field',
            'Field',
            field
        )
    else
        joinPart   = 'INNER JOIN ' + table.name + '.' + field.columnName + ' = '
        joinPart  += field.refTableName + '.' + field.refColumnName
        joinPart

exports.buildInnerJoin= buildInnerJoin

###*
# Generate OUTER JOIN for an optionnal foreign key or inverse relation
# @param    {Object}        table       Source table object
# @param    {Object}        field       Source field object
# @param    {Object}        relation    Inverse relation if exists
# @return   {String}                    An outer join part
###
buildLeftOuterJoin = (table, field, relation) ->
    ###*
    # Check params and process inner join build if ok
    ###
    errors = []
    if not (table instanceof Table)
        return new rmErrors.ParameterError(
            'table',
            'Table',
            table
        )

    ###*
    # Twice should be error to breack, so not else if here
    ###
    if not (field instanceof Field)
        errors.push new rmErrors.ParameterError(
            'field',
            'Field',
            field
        )
    if not (relation instanceof Relation)
        errors.push new rmErrors.ParameterError(
            'relation',
            'Relation',
            relation
        )

    ###*
    # With this relation type, one parameter (field or relation) should be
    # bad, but not twice !
    ###
    if errors.length is 2
        return errors

    else
        ###*
        # If it's an optional foreign key,
        ###
        if not relation?
            joinPart  = 'LEFT OUTER JOIN ' + table.name + ' ON '
            joinPart += table.name + '.' + field.columnName
            joinPart += ' = ' + field.refTableName + '.' + field.refColumnName
        else
            joinPart  = 'LEFT OUTER JOIN ' + table.name + ' ON '
            joinPart += table.name + '.' + relation.originColumn
            joinPart += ' = ' + relation.destTable + '.' + relation.destColumn

        joinPart

exports.buildLeftOuterJoin = buildLeftOuterJoin

###*
# validate buildGenericGetFromSection function params
# @param    {String}    objectType          Type of main object
# @param    {Array}     orderedSelect       A select array sorted by depth
# @param    {Object}    dbStructure         DatabaseStructure instance
# @return   {String}                        From section of a generic get query
###
checkBuildGenericGetFromSection = (objectType, orderedSelect, dbStructure) ->
    errors = []

    if not (typeof objectType is 'string')
        errors.push new rmErrors.ParameterError(
            'objectType',
            'string',
            objectType
        )
    if not (isStringArray orderedSelect)
        errors.push new rmErrors.ParameterError(
            'orderedSelect',
            'string-array',
            orderedSelect
        )
    if not (dbStructure instanceof DatabaseStructure)
        errors.push new rmErrors.ParameterError(
            'dbStructure',
            'DatabaseStructure',
            dbStructure
        )

    errors

exports.checkBuildGenericGetFromSection = checkBuildGenericGetFromSection

###*
# Generate from selection of a generic get query
# @param    {String}    objectType          Type of main object
# @param    {Array}     orderedSelect       A select array sorted by depth
# @param    {Object}    dbStructure         DatabaseStructure instance
# @return   {String}                        From section of a generic get query
###
buildGenericGetFromSection = (objectType, orderedSelect, dbStructure) ->
    errors          = []
    pathProcessed   = []
    fromParts       = []

    ###*
    # Check function params
    ###
    paramsErrors = checkBuildGenericGetFromSection(
        objectType,
        orderedSelect,
        dbStructure
    )

    if paramsErrors.length isnt 0
        Q.fcall ->
            throw paramsErrors
    else
        for path in orderedSelect
            do (path) ->
                ###*
                # Split path to process
                ###
                parts           = path.split('.')
                previousPart    = objectType
                previousPath    = objectType

                for part in parts
                    do (part) ->
                        previousPath += '.' + part
                        ###*
                        # Process only if it's a new part
                        ###
                        if pathProcessed.indexOf(part) is -1
                            table       = dbStructure.getTable previousPart
                            field       = table.getField part
                            fromPart    = null

                            ###*
                            # Check type of relation
                            # If foreignkey and required : INNER JOIN
                            # Else, it's an OUTER JOIN
                            ###
                            if table.isForeignKey(part) and field.isRequired()
                                fromPart      = buildInnerJoin table, field
                                previousPart  = field.refTableName

                            else if table.isRelationExists(part)
                                rel      = table.getInverseForeignKey part
                                fromPart = buildLeftOuterJoin table, field, rel

                            ###*
                            # Only string return is valid
                            ###
                            if typeof fromPart is 'string'
                                fromParts.push fromPart
                                pathProcessed.push previousPath
                            else
                                errors.push fromPart

        if errors.length isnt 0
            Q.fcall ->
                throw errors
        else
            Q.fcall ->
                fromParts.join ' '

exports.buildGenericGetFromSection = buildGenericGetFromSection
