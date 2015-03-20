'use strict'

###*
# @fileOverview ComplexField objects used to build database structure
###

class ComplexField
    constructor: (field) ->
        @criticality    = 0
        @type           = field.refTableName
        @isNullable     = field.isNullable
        @isViewable     = false
        @isArray        = field.isArray

module.exports = ComplexField
