'use strict'

###*
# @fileOverview Relation objects used to build database structure
###

class Relation

    ###*
    # Constructor of Relation class
    # @param {Object} relationData Data to use to create a new Relation object
    # @return {Object} A new relation object if params are valid
    # @throw {Object} ParameterError is invalid param
    ###
    constructor: (relationData) ->

        @originColumn   = relationData.originColumn
        @destTable      = relationData.destTable
        @destColumn     = relationData.destColumn
        @isInverse      = relationData.isInverse

module.exports = Relation
