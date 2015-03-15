'use strict'

###*
# @fileOverview Fields objects used to build database structure
###

class Field
    constructor: (fieldData) ->

        @tableSchema        = fieldData.tableSchema
        @tableName          = fieldData.tableName
        @columnName         = fieldData.columnName
        @ordinalPosition    = fieldData.ordinalPosition
        @defaultValue       = fieldData.defaultValue
        @nullable           = fieldData.isNullable
        @dataType           = fieldData.dataType
        @charMaxLength      = fieldData.charMaxLength
        @charOctetLength    = fieldData.charOctetLength
        @numPrecision       = fieldData.numPrecision
        @numScale           = fieldData.numScale
        @datetimePrecision  = fieldData.datetimePrecision
        @charSetName        = fieldData.charSetName
        @collationName      = fieldData.collationName
        @columnType         = fieldData.columnType
        @columnKey          = fieldData.columnKey
        @extra              = fieldData.extra

    isAutoIncrement: ->
        @extra? and @extra is 'auto_increment'

    isNullable: ->
        @nullable is 'yes'

    isPrimaryKey: ->
        @columnKey is 'pri'

    isRequired: ->
        @nullable? and @defaultValue is null

module.exports = Field
