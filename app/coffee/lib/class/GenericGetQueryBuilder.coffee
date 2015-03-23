'use strict'

###*
# @fileOverview This file contains the GenericGetQueryBuilder class
# @class GenericGetQueryBuilder
###

isArray = require('util').isArray

containsErrorValue  = require('../global.js').containsErrorValue
DatabaseStructure   = require './DatabaseStructure.js'
isNotEmptyString    = require('../global.js').isNotEmptyString
ormUtils            = require '../orm.js'
Q                   = require 'q'
rmErrors            = require '../errors.js'

class GenericGetQueryBuilder

    ###*
    # Constructor of GenericGetQueryBuilder class
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
        ###*
        # Execute parameters check
        ###
        errors = checkParams(
            api,
            connection,
            getStructure,
            dbStructure,
            doTotalCount
        )

        if errors.length isnt 0
            return errors
        else
            @api                = api
            @connection         = connection
            @doTotalCount       = doTotalCount
            @getStructure       = getStructure
            @databaseStructure  = databaseStructure

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
            errors.push new rmErrors.ParameterError(
                'api',
                'object'
                api
            )
        else if not connection? or not (Object.keys(connection).length isnt 0)
            errors.push new rmErrors.ParameterError(
                'connection',
                'object'
                connection
            )
        else if not (getStructure instanceof GenericGetStructureMain)
            errors.push new rmErrors.ParameterError(
                'getStructure',
                'GenericGetStructureMain'
                getStructure
            )
        else if not (dbStructure instanceof DatabaseStructure)
            errors.push new rmErrors.ParameterError(
                'dbStructure',
                'DatabaseStructure'
                dbStructure
            )
        else if not ((doTotalCount is true) or (doTotalCount is false))
            errors.push new rmErrors.ParameterError(
                'doTotalCount',
                'boolean'
                doTotalCount
            )
        errors

    ###*
    # Create queries for generic get request (ids, main request and for arrays)
    # @return   {Object}    An object with all requests
    # @throw    {Object}    Errors occured during creation steps
    ###
    createQueries: () ->

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
        for path in @getStructure
            if @dbStructure.containsInverseRelation(path)
                queriesStructure.arrayFields.push path
            else
                queriesStructure.simpleFields.push path

    ###*
    # Build the query to return main object ids which match the user request
    # @param    {Object}    queriesStructure    Structure to store queries
    # @return   {Object}                        Structure with query set
    # @throw                                    DatabaseError if occurs
    ###
    buildMainObjectIdsQuery: (queriesStructure) ->
        ormUtils.sortSelectByDepth @getStructure.select
            .then(
                (orderedSelect) ->
                    ormUtils.buildGenericGetFromSection(
                        @getStructure.returnType,
                        orderedSelect,
                        @dbStructure
                    )
            )


module.exports = GenericGetStructureOrder
