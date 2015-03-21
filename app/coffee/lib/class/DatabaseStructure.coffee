'use strict'

###*
# @fileOverview DatabaseStructure class to build the main singleton object
###

class DatabaseStructure

    ###*
    # Constructor used to create new DatabaseStructure object
    ###
    constructor: () ->
        @tables = []

    ###*
    # Add a new table if not already exists
    # @param {Object} table Table to add
    # @return {Boolean} True if table added, else false
    ###
    addTable: (table) ->
        if @containsTable(table.name)
            false
        else
            @tables.push table
            true

    ###*
    # Check if the DatabaseStructure contains a table where name equal to param
    # @param {String} tableName Requested name
    # @return {Boolean} True if table exists
    ###
    containsTable: (tableName) ->
        match = []
        match.push table for table in @tables when table.name is tableName

        if match.length > 0 then true else false

    ###*
    # Return table object where table name is same than param sent
    # @param {String} tableName Requested name
    # @return {Object|null} Return table if exists, null else
    ###
    getTable: (tableName) ->
        match = []
        match.push table for table in @tables when table.name is tableName

        if match.length > 0 then match[0] else null

    ###*
    # To assure backward compatibility
    # @return {Object} An object same as v1 database structure
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

    checkPath: (path, parentTable) ->


module.exports = DatabaseStructure
