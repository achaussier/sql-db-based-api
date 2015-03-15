'use strict'

###*
# @fileOverview Relation objects used to build database structure
###

class Relation
    ###*
    # Constructor of Relation class
    # @param {String} originColumn Column of current table
    # @param {String} destTable Table referenced by this relation
    # @param {String} destColumn Column referenced by this relation
    # @return {Object} A new relation object if params are valid
    # @throw {Object} ParameterError is invalid param
    ###
    constructor: (originColumn, destTable, destColumn) ->

        @originColumn = originColumn.toLowerCase()
        @destTable = destTable.toLowerCase()
        @destColumn = destColumn.toLowerCase()

module.exports = Relation
