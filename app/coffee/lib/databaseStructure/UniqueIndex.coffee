'use strict'

###*
# @fileOverview UniqueIndex objects used to build database structure
###

class UniqueIndex

    ###*
    # Constructor used to build a new UniqueIndex object
    # @param {Object} indexPart A part (column) of an unique index
    ###
    constructor: (indexPart) ->
        @columns   = []
        @name      = indexPart.indexName
        @tableName = indexPart.tableName
        @columns.push indexPart.columnName

    ###*
    # Add a column if not exists for this index
    # @param {String} columnName New column name to add
    # @return {Boolean} True if column added, else false
    ###
    addColumn: (columnName) ->
        if not @containsColumn columnName
            @columns.push columnName
            true
        else
            false

    ###*
    # Check if columns exists for this index
    # @param {String} columnName Column name to search
    # @return {Boolean} True if columnName already present, else false
    ###
    containsColumn: (columnName) ->
        if @columns.indexOf(columnName) is -1 then false else true

module.exports = UniqueIndex
