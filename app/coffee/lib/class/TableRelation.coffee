'use strict'

###*
# @fileOverview TableRelation objects used to build database structure
###

class TableRelation
    constructor: (@name) ->
        @relations = []
        @inverseRelations = []

    addRelation: (relation) ->
        @relations.push relation

    addInverseRelation: (relation) ->
        @inverseRelations.push relation

module.exports = TableRelation
