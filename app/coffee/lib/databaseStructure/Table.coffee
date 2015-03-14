'use strict'

###*
# @fileOverview Tables objects used to build database structure
###

class Table
    constructor: (@name) ->
        @fields =
            simple: {}
            complex: {}
        @parameters =
            required: []
            optional: []
        @aliases = {}
        @inverseAliases = {}
        @primaryKeys = []
        @foreignKeys = []
        @inverseForeignKeys = []
        @uniqueIndexes =
            byColumnName: {}
            byIndexName: {}
        @isView = false

module.exports = Table
