'use strict'

###*
# @fileOverview ComplexField objects used to build database structure
###

class ComplexField
    constructor: (@name) ->
        @criticality = 0
        @type = null
        @isNullable = null
        @isViewable = null
        @isArray = null

module.exports = ComplexField
