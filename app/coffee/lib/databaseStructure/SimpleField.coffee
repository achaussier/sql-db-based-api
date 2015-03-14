'use strict'

###*
# @fileOverview SimpleField objects used to build database structure
###

class SimpleField
    constructor: (@name) ->
        @criticality = 0
        @type = null
        @isNullable = null
        @isViewable = null
        @maxLength = null
        @defaultValue = null
        @isAutoIncrement = null

module.exports = SimpleField
