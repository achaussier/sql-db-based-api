'use strict'

###*
# @fileOverview SimpleField objects used to build database structure
###

class SimpleField

    ###*
    # Constructor used to create new SimpleField object
    # @param {Object} fieldData Field data used to build object
    ###
    constructor: (field) ->
        @criticality        = 0
        @type               = field.dataType
        @isNullable         = field.isNullable()
        @isViewable         = true
        @maxLength          = field.getMaxLength()
        @defaultValue       = field.defaultValue
        @isAutoIncrement    = field.isAutoIncrement()

module.exports = SimpleField
