'use strict'

###*
# @fileOverview This file contains the Maria10QueryBuilder class
# @class Maria10QueryBuilder
###

###*
# Required modules
###
apiErrors  = require '../errors.js'
ormUtils   = require '../orm.js'
Q          = require 'q'

###*
# Required custom classes
###
Field           = require './Field.js'
QueryBuilder    = require './QueryBuilder.js'
Relation        = require './Relation.js'
Table           = require './Table.js'

class Maria10QueryBuilder extends QueryBuilder

    ###*
    # Constructor of Maria10QueryBuilder class
    # @constructor
    # @param    {Object}    api             Main api object
    # @param    {Object}    connection      Current connection
    # @param    {String}    getStructure    Structure with data to request
    # @param    {String}    dbStructure     DatabaseStructure instance
    # @param    {Boolean}   doTotalCount    Need to get the total results ?
    # @return   {Object}                    GenericGetQueryBuilder instance
    # @throw    {Object}                    ParameterError if bad param
    ###
    constructor: (api, connection, getStructure, doTotalCount, dbStructure) ->
        super

    ###*
    # Generate INNER JOIN for a required foreign key
    # @param    {Object}    table       Source table object
    # @param    {Object}    field       Source field object
    # @return   {String}                An inner join part
    ###
    buildInnerJoin: (table, field) ->
        ###*
        # Check params and process inner join build if ok
        ###
        if not (table instanceof Table)
            return new apiErrors.ParameterError(
                'table',
                'Table',
                table
            )
        else if not (field instanceof Field)
            return new apiErrors.ParameterError(
                'field',
                'Field',
                field
            )
        else
            joinPart  = 'INNER JOIN ' + field.refTableName
            joinPart += ' ON ' + table.name + '.' + field.columnName
            joinPart += ' = ' + field.refTableName + '.' + field.refColumnName
            joinPart

    ###*
    # Generate OUTER JOIN for an optionnal foreign key or inverse relation
    # @param    {Object}        table       Source table object
    # @param    {Object}        field       Source field object
    # @param    {Object}        relation    Inverse relation if exists
    # @return   {String}                    An outer join part
    ###
    buildLeftOuterJoin: (table, field, relation) ->
        ###*
        # Check params and process inner join build if ok
        ###
        errors = []
        if not (table instanceof Table)
            return new apiErrors.ParameterError(
                'table',
                'Table',
                table
            )

        ###*
        # Twice should be error to breack, so not else if here
        ###
        if not (field instanceof Field)
            errors.push new apiErrors.ParameterError(
                'field',
                'Field',
                field
            )
        if not (relation instanceof Relation)
            errors.push new apiErrors.ParameterError(
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
                part  = 'LEFT OUTER JOIN ' + field.refTableName
                part += ' ON ' + table.name + '.' + field.columnName
                part += ' = ' + field.refTableName + '.' + field.refColumnName
            else
                part  = 'LEFT OUTER JOIN ' + relation.destTable
                part += ' ON ' + table.name + '.' + relation.originColumn
                part += ' = ' + relation.destTable + '.' + relation.destColumn

            part

module.exports = Maria10QueryBuilder
