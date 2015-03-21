'use strict'

###*
# @fileOverview DatabaseStructure class to build the main singleton object
###

isStringArray = require('../global.js').isStringArray

class DatabaseStructure

    ###*
    # Constructor used to create new DatabaseStructure object
    # @return   {Object}    A new instance of DtabaseStructure
    ###
    constructor: () ->
        @tables = []

    ###*
    # Add a new table if not already exists
    # @param    {Object}    table   Table to add
    # @return   {Boolean}           True if table added, else false
    ###
    addTable: (table) ->
        if @containsTable(table.name)
            return false

        @tables.push table
        true

    ###*
    # Check if the DatabaseStructure contains a table where name equal to param
    # @param    {String}    tableName   Requested name
    # @return   {Boolean}               True if table exists
    ###
    containsTable: (tableName) ->
        match = []
        match.push table for table in @tables when table.name is tableName

        match.length > 0

    ###*
    # Return table object where table name is same than param sent
    # @param    {String}        tableName   Requested name
    # @return   {Object|null}               Return table if exists, null else
    ###
    getTable: (tableName) ->
        match = []
        match.push table for table in @tables when table.name is tableName

        if match.length > 0
            return match[0]
        null

    ###*
    # To assure backward compatibility
    # @return   {Object}    An object same as v1 database structure
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    versionOneRender: () ->
        structure =
            struct:
                objects: {}

        for table in @tables when not table.isView
            do (table) ->
                structure.struct.objects[table.name] = table.versionOneRender()
        structure

    ###*
    # Check if a path from an object to another is valid
    # @param    {String}    path            Path to test
    # @param    {String}    parentTable     Parent object for the path
    # @return   {Boolean}                   True if valid, else false
    ###
    checkPath: (path, parentTable) ->
        ###*
        # If it's the first loop, split path string
        ###
        if not isStringArray(path)
            arrayPath = path?.split('.')
        else
            arrayPath = path

        ###*
        # Get parent table and check that field exists or return false
        ###
        tableObj        = @getTable parentTable
        field           = arrayPath?.shift()
        fieldObj        = tableObj?.getField field
        fieldRelation   = tableObj?.isRelationExists field


        ###*
        # If it's the last element of path and table exists,    return true
        # If table or field not exists,                         return false
        # If it's not a valid relation field                    return false
        # Else, get the real table name (in case of alias) or shift the name of
        # relation and recurse
        ###
        switch
            when     arrayPath?.length is 0 and     tableObj        then true
            when not fieldObj               and not fieldRelation   then false
            when not fieldRelation                                  then false
            else
                newParent = fieldObj?.refTableName or arrayPath.shift()
                @checkPath arrayPath, newParent

module.exports = DatabaseStructure
