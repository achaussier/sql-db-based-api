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
    ###
    addColumn: (columnName) ->
        if @columns.indexOf(columnName) is -1
            @columns.push columnName
            true
        else
            false

module.exports = UniqueIndex
