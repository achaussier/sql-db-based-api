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
        @refTableName       = fieldData.refTableName
        @refColumnName      = fieldData.refColumnName
        @tableType          = fieldData.tableType
        @uniqueIndexName    = fieldData.uniqueIndexName

    getMaxLength: ->

        switch @dataType
            when 'varchar', 'text' then @charMaxLength
            when 'int' then @numPrecision
            else null

    isAutoIncrement: ->
        @extra? and @extra is 'auto_increment'

    isNullable: ->
        @nullable is 'yes'

    isPrimaryKey: ->
        @columnKey is 'pri'

    isRequired: ->
        !@nullable? and !@defaultValue?

module.exports = Field
