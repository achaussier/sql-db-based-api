'use strict'

###*
# @fileOverview This file contains the QueryBuilder class
# @class QueryBuilder
###

###*
# Required modules
###
apiErrors           = require '../errors.js'
clone               = require 'clone'
mysql               = require 'mysql'
ormUtils            = require '../orm.js'
Q                   = require 'q'

###*
# Required methods
###
containsErrorValue  = require('../global.js').containsErrorValue
isArray             = require('util').isArray
isStringArray       = require('../global.js').isStringArray

###*
# Required custom classes
###
DatabaseStructure               = require './DatabaseStructure.js'
GenericGetStructureConstraint   = require './GenericGetStructureConstraint.js'
GenericGetStructureMain         = require './GenericGetStructureMain.js'

class QueryBuilder

    ###*
    # Constructor of QueryBuilder class
    # @constructor
    # @param    {Object}    api             Main api object
    # @param    {Object}    connection      Current connection
    # @param    {String}    getStructure    Structure with data to request
    # @param    {String}    dbStructure     DatabaseStructure instance
    # @param    {Boolean}   doTotalCount    Need to get the total results ?
    # @return   {Object}                    QueryBuilder instance
    # @throw    {Object}                    ParameterError if bad param
    ###
    constructor: (api, connection, getStructure, doTotalCount, dbStructure) ->
        ###*
        # Execute parameters check
        ###
        errors = @checkParams(
            api,
            connection,
            getStructure,
            doTotalCount,
            dbStructure
        )

        if errors.length isnt 0
            return errors
        else
            @api                = api
            @connection         = connection
            @doTotalCount       = doTotalCount
            @getStructure       = getStructure
            @dbStructure        = dbStructure

    ###*
    # Check constructor params
    # @param    {Object}    api             Main api object
    # @param    {Object}    connection      Current connection
    # @param    {String}    getStructure    Structure with data to request
    # @param    {String}    dbStructure     DatabaseStructure instance
    # @param    {Boolean}   doTotalCount    Need to get the total results ?
    # @return   {Array}                     Array with parameter errors
    # @throw    {Object}                    ParameterError if bad param
    ###
    checkParams: (api, connection, getStructure, doTotalCount, dbStructure) ->
        errors = []
        ###*
        # Check if params are valid
        ###
        if not api? or not (Object.keys(api).length isnt 0)
            errors.push new apiErrors.ParameterError(
                'api',
                'object'
                api
            )
        else if not connection? or not (Object.keys(connection).length isnt 0)
            errors.push new apiErrors.ParameterError(
                'connection',
                'object'
                connection
            )
        else if not (getStructure instanceof GenericGetStructureMain)
            errors.push new apiErrors.ParameterError(
                'getStructure',
                'GenericGetStructureMain'
                getStructure
            )
        else if not (dbStructure instanceof DatabaseStructure)
            errors.push new apiErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure'
                dbStructure
            )
        else if not ((doTotalCount is true) or (doTotalCount is false))
            errors.push new apiErrors.ParameterError(
                'doTotalCount',
                'boolean'
                doTotalCount
            )
        errors

    ###*
    # Extract table and field from a constraint field
    # @param    {String}    constraintField     Field defined in constraint
    # @param    {String}    objectType          Main object for the request
    # @return   {Object}                        Two keys 'table' and 'field'
    ###
    processContraintField: (constraintField, objectType) ->
        result = {}

        if (constraintField.indexOf( '.') is -1)
            ###
            # If it's a field
            ###
            result.tableName    = objectType
            result.columnName   = constraintField
        else
            ###*
            # If it's a field of another table
            ###
            splitData           = /^(.*)\.(.*)$/.exec(constraintField)
            result.tableName    = splitData[1]
            result.columnName   = splitData[2]
        result

    ###*
    # Create queries for generic get request (ids, main request and for arrays)
    # @return   {Object}    An object with all requests
    # @throw    {Object}    Errors occured during creation steps
    ###
    createGenericGetQueries: () ->

        @generateQueriesStructure()
            .then @separateArrayValues
            .then @buildMainObjectIdsQuery
            .then @buildMainObjectQuery
            .then @buildArrayValuesQueries
            .catch (error) ->
                throw error

    ###*
    # Generate structure to store queries
    # @return   {Object}    Query storage object
    ###
    generateQueriesStructure: () ->
        Q.fcall ->
            simpleFields            : []
            arrayFields             : []
            getIdsQuery             : null
            getMainObjectQuery      : null
            getArrayValuesQueries   : {}

    ###*
    # Separate main object fields with foreign keys and inverse 0n relations
    # @param    {Object}    queriesStructure    Structure to store queries
    # @return   {Object}                        Structure with fields separate
    # @throw                                    DatabaseError if occurs
    ###
    separateArrayValues: (queriesStructure) ->
        for path in @getStructure.select
            if @dbStructure.containsInverseRelation(path)
                queriesStructure.arrayFields.push path
            else
                queriesStructure.simpleFields.push path
        queriesStructure

    ###*
    # Sort a select array by depth
    # @param    {Array}     selectArray     Contains all path requested
    # @return   {Array}                     Select array sorted by depth
    # @throw                                ParameterError if bad parameter
    ###
    sortSelectByDepth: (selectArray) ->
        ###*
        # Clone select array to keep original array intact
        ###
        orderedSelect = clone selectArray

        ###*
        # Check param and if it's ok, sort clone array and return it
        ###
        if not isStringArray(selectArray)
            Q.fcall ->
                throw new apiErrors.ParameterError(
                    'selectArray',
                    'string-array',
                    selectArray
                )
        else
            orderedSelect.sort (a, b) ->
                return (b.split('.').length - 1) - (a.split('.').length - 1)

            Q.fcall ->
                orderedSelect

    ###*
    # validate buildGenericGetFromSection function params
    # @param    {String}    objectType          Type of main object
    # @param    {Array}     orderedSelect       A select array sorted by depth
    # @param    {Object}    dbStructure         DatabaseStructure instance
    # @return   {String}                        From section of a get query
    ###
    checkBuildGetFromSection: (objectType, orderedSelect, dbStructure) ->
        errors = []

        if not (typeof objectType is 'string')
            errors.push new apiErrors.ParameterError(
                'objectType',
                'string',
                objectType
            )
        if not (isStringArray orderedSelect)
            errors.push new apiErrors.ParameterError(
                'orderedSelect',
                'string-array',
                orderedSelect
            )
        if not (dbStructure instanceof DatabaseStructure)
            errors.push new apiErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure',
                dbStructure
            )

        errors

    ###*
    # Generate from selection of a generic get query
    # @param    {String}    objectType          Type of main object
    # @param    {Array}     orderedSelect       A select array sorted by depth
    # @param    {Object}    dbStructure         DatabaseStructure instance
    # @return   {String}                        From section of a generic get
    ###
    buildGetFromSection: (objectType, orderedSelect, dbStructure) ->
        errors          = []
        pathProcessed   = []
        fromParts       = []

        ###*
        # Check function params
        ###
        paramsErrors = @checkBuildGetFromSection(
            objectType,
            orderedSelect,
            dbStructure
        )

        if paramsErrors.length isnt 0
            return Q.fcall ->
                throw paramsErrors

        for path in orderedSelect
            do (path) =>
                ###*
                # Split path to process
                ###
                parts           = path.split('.')
                previousPart    = objectType
                previousPath    = objectType

                for part in parts
                    do (part) =>
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
                            if table.isForeignKey(part) and field?.isRequired()
                                fromPart      = @buildInnerJoin table, field
                                previousPart  = field.refTableName

                            else if table.isRelationExists(part)
                                rel      = table.getInverseForeignKey part
                                fromPart = @buildLeftOuterJoin table, field, rel

                            ###*
                            # Only string return is valid
                            ###
                            if typeof fromPart is 'string'
                                fromParts.push fromPart
                                pathProcessed.push previousPath
                            else
                                errors.push fromPart

        if errors.length isnt 0
            return Q.fcall ->
                throw errors

        return Q.fcall ->
            fromParts.join ' '

    ###*
    # Generate where section of a generic query
    # @param    {String}    objectType          Type of main object
    # @param    {Array}     constraints         A constraints array
    # @param    {Object}    dbStructure         DatabaseStructure instance
    # @return   {String}                        From section of a generic get
    ###
    buildGetWhereSection: (objectType, constraints) ->
        errors          = []
        sqlConstraints  = []

        ###*
        # Check params of method
        ###
        if not (typeof objectType is 'string')
            errors.push new apiErrors.ParameterError(
                'objectType',
                'string',
                objectType
            )
        if not (isArray constraints)
            errors.push new apiErrors.ParameterError(
                'constraints',
                'array',
                constraints
            )

        if errors.length isnt 0
            return Q.fcall ->
                throw errors

        ###*
        # Process each constraints to build the where section
        ###
        for constraint in constraints
            do (constraint) =>
                sql = ''
                if not (constraint instanceof GenericGetStructureConstraint)
                    errors.push errors.push new apiErrors.ParameterError(
                        'constraint',
                        'GenericGetStructureConstraint',
                        constraint
                    )
                else
                    ###*
                    # Add link if exists
                    ###
                    if (constraint.link isnt null)
                        sql += ' ' + constraint.link + ' '

                    ###*
                     # Check if field is a field of object type or another field
                    ###
                    data = @processContraintField(constraint.field, objectType)

                    sql += ' `' + data.tableName + '`.`' + data.columnName + '`'

                    # Add operator and value
                    sql += ' ' + constraint.operator + ' '

                    if @isListOfValue(constraint.operator)
                        sql += @escapeListValues(constraint.value)
                    else
                        sql += constraint.operator + ' '
                        sql += mysql.escape(constraint.value)

                sqlConstraints.push sql

        if errors.length isnt 0
            return Q.fcall ->
                throw  errors

        Q.fcall ->
            sqlConstraints.join ' '

    ###*
    # Escape list values
    # @param    {Array}     values      Values to prepare before insert in query
    # @return   {String}                String to be include in query
    ###
    escapeListValues: (values) ->
        escapedData = []
        escapedData.push mysql.escape(data) for data in values

        result = '('
        result += escapedData.join(',')
        result += ')'
        result

    ###*
    # Check if operator is 'in' or 'not in'
    # @param    {String}    operator            Operator used in constraint
    # @return   {Boolean}                       True if in/not in operator
    ###
    isListOfValue: (operator) ->
        (operator is 'in') or (operator is 'not in')

    ###*
    # Build the query to return main object ids which match the user request
    # @param    {Object}    queriesStructure    Structure to store queries
    # @return   {Object}                        Structure with query set
    # @throw                                    DatabaseError if occurs
    ###
    buildMainObjectIdsQuery: (queriesStructure) ->
        if not queriesStructure?.hasOwnProperty 'getIdsQuery'
            return Q.fcall ->
                errors = []
                errors.push new apiErrors.ParameterError(
                    'queriesStructure',
                    'object',
                    queriesStructure
                )
                throw errors

        @sortSelectByDepth @getStructure.select
            .then (orderedSelect) =>
                @buildGetFromSection(
                    @getStructure.returnType,
                    orderedSelect,
                    @dbStructure
                )
            .then (fromParts) =>
                constraints = @getStructure.constraints
                @buildGetWhereSection @getStructure.returnType, constraints
                    .then (whereParts) =>
                        returnType  = @getStructure.returnType
                        table       = @dbStructure.getTable returnType
                        pk          = table.getPrimaryKeys()

                        query   = 'SELECT ' + pk
                        query  += ' FROM ' + returnType

                        ###*
                        # If some join should be done, add id
                        ###
                        if fromParts isnt ''
                            query  += ' ' + fromParts

                        ###*
                        # Add WHERE constraints only if we have constraints
                        ###
                        if whereParts isnt ''
                            query += ' WHERE ' + whereParts

                        Q.fcall ->
                            queriesStructure.getIdsQuery = query + ';'
            .catch (error) ->
                throw error

    ###*
    # Generate INNER JOIN for a required foreign key
    # @param    {Object}    table       Source table object
    # @param    {Object}    field       Source field object
    # @return   {String}                An inner join part
    ###
    buildInnerJoin: (table, field) ->
        new apiErrors.ServerError(
            'buildInnerJoin should be extended by a sub class'
        )

    ###*
    # Generate OUTER JOIN for an optionnal foreign key or inverse relation
    # @param    {Object}        table       Source table object
    # @param    {Object}        field       Source field object
    # @param    {Object}        relation    Inverse relation if exists
    # @return   {String}                    An outer join part
    ###
    buildLeftOuterJoin: (table, field, relation) ->
        new apiErrors.ServerError(
            'buildLeftOuterJoin should be extended by a sub class'
        )

module.exports = QueryBuilder
