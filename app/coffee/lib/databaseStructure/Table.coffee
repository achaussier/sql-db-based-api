'use strict'

###*
# @fileOverview Tables objects used to build database structure
###

ComplexField = require './ComplexField.js'
SimpleField = require './SimpleField.js'
UniqueIndex = require './UniqueIndex.js'
isArray = require('util').isArray

class Table

    ###*
    # Constructor used to create new Table object
    # @param {Object} tableData Table data used to build object
    ###
    constructor: (tableData) ->
        @name           = tableData.name
        @fields         = []
        @uniqueIndexes  = []
        @relations      = []
        @isView         = tableData.isView or false

    ###*
    # Add a new field if not already exists
    # @param {Object} Field to add
    # @return {Boolean} True if field added, else false
    ###
    addField: (field) ->
        if @containsField(field.columnName)
            false
        else
            @fields.push field
            true

    ###*
    # Add a new relation if not already exists
    # @param {Object} Relation to add
    # @return {Boolean} True if relation added, else false
    ###
    addRelation: (relationToAdd) ->
        relation = []

        ###*
        # Search if relation already exists
        ###
        relation.push rel for rel in @relations when (
            rel.originColumn is relationToAdd.originColumn and
            rel.destTable is relationToAdd.destTable and
            rel.destColumn is relationToAdd.destColumn
        )

        if relation.length is 0
            ###*
            # If not exists, add it
            ###
            @relations.push relationToAdd
            true
        else
            false


    ###*
    # Add a new filed if not already exists
    # @param {Object} Field to add
    # @return {Boolean} True if field added, else false
    ###
    addUniqueIndexPart: (indexPart) ->
        ###*
        # Get unique index if exists
        ###
        indexes = []
        indexes.push idx for idx in @uniqueIndexes when (
            idx.name is indexPart.indexName
        )

        ###*
        # If no index match, create a new index
        ###
        if indexes.length is 0
            @uniqueIndexes.push new UniqueIndex(indexPart)
            true

        else if indexes[0].containsColumn indexPart.columnName
            ###*
            # If this part already exists
            ###
            false

        else
            ###*
            # If index is incomplet, update it
            ###
            addReturn = indexes[0].addColumn indexPart.columnName
            if addReturn and indexes[0].columns.length is 2 then true else false

    ###*
    # Check if this table contains a field where name equal to param
    # @param {String} fieldName Requested name
    # @return {Boolean} True if field exists
    ###
    containsField: (fieldName) ->
        match = []
        match.push field for field in @fields when field.columnName is fieldName

        if match.length > 0 then true else false

    ###*
    # To populate versionOneRender object
    # @return {Object} Simple fields for versionOneRender
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    getSimpleFieldsForV1: () ->

        ###*
        # Get all fields which match simple object specification of v1
        ###
        matchFields = []
        matchFields.push field for field in @fields when !field.refTableName?

        ###*
        # For each field, create a SimpleField object to render it for v1
        ###
        render = {}
        for matchField in matchFields
            do (matchField) ->
                render[matchField.columnName] = new SimpleField(matchField)

        render

    ###*
    # To populate versionOneRender object
    # @return {Object} Complex fields for versionOneRender
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    getComplexFieldsForV1: () ->

        ###*
        # Get all fields which match complex object specification of v1
        ###
        matchFields = []
        matchFields.push field for field in @fields when field.refTableName?

        ###*
        # For each field, create a ComplexField object to render it for v1
        ###
        render = {}
        for matchField in matchFields
            do (matchField) ->
                render[matchField.columnName] = new ComplexField(matchField)

        render

    ###*
    # Return required fields for this table
    # @return {Array} Array with all required fields name
    ###
    getRequiredFieldsName: () ->

        ###*
        # Get all fields not nullable and with null default value
        ###
        requireFields = []
        requireFields.push field.columnName for field in @fields when not
            field.isNullable() and
            field.defaultValue is null

        requireFields

    ###*
    # Return optional fields name for this table
    # @return {Array} Array with all optional fields name
    ###
    getOptionalFieldsName: () ->

        ###*
        # Get all fields not nullable and with not null default value or
        # nullable
        ###
        optionalFields = []
        optionalFields.push field.columnName for field in @fields when (
            field.isNullable())

        optionalFields

    ###*
    # Return aliases fields name for this table
    # @return {Object} Object with all aliases
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    getAliasesForV1: () ->

        ###*
        # Get all fields with refTableName not null and columName not equal
        # refTableName
        ###
        als = {}
        als[field.refTableName] = field.columnName for field in @fields when (
            field.refTableName? and field.refTableName isnt field.columnName)

        als

    ###*
    # Return inverse aliases for this table
    # @return {Array} Array with all inverse aliases
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    getInverseAliasesForV1: () ->

        ###*
        # Get all fields with refTableName not null and columName not equal
        # refTableName
        ###
        invAls = {}
        invAls[field.columnName] = field.refTableName for field in @fields when(
            field.refTableName? and field.refTableName isnt field.columnName)

        invAls

    ###*
    # Return primary keys for this table
    # @return {Array} Array with all primary keys name
    ###
    getPrimaryKeys: () ->

        ###*
        # Get all fields with columnKey is 'pri'
        ###
        pKeys = []
        pKeys.push field.columnName for field in @fields when (
            field.columnKey is 'pri'
        )

        pKeys

    ###*
    # Return foreign keys for this table
    # @return {Array} Array with all foreign keys name
    ###
    getForeignKeys: () ->

        ###*
        # Get all fields with refTable not null
        ###
        fks = []
        fks.push field.columnName for field in @fields when field.refTableName?

        fks

    ###*
    # Return inverse foreign keys for this table
    # @return {Array} Array with all inverse foreign keys name
    ###
    getInverseForeignKeys: () ->

        ###*
        # Get all destTable with originColumn is null
        ###
        invForeignKeys = []
        invForeignKeys.push rel.destTable for rel in @relations when (
            rel.originColumn is null
        )

        invForeignKeys

    ###*
    # Return unique indexes by columnName for this table
    # @return {Object} Object with all unique indexes
    ###
    getUniqueIndexesByColumn: () ->

        ###*
        # Get all fields with refTableName not null and columName not equal
        # refTableName
        ###
        uIndexes = {}
        for index in @uniqueIndexes
            do (index) ->
                for column in index.columns
                    do (column) ->
                        if isArray(uIndexes[column])
                            uIndexes[column].push index.name
                        else
                            uIndexes[column] = [ index.name ]

        uIndexes

    ###*
    # Return unique indexes by name for this table
    # @return {Object} Object with all unique indexes
    ###
    getUniqueIndexesByName: () ->

        ###*
        # Get columns for index name
        ###
        uIndexes = {}
        uIndexes[index.name] = index.columns for index in @uniqueIndexes

        uIndexes

    ###*
    # To assure backward compatibility
    # @return {Object} An object same as v1 database structure
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    versionOneRender: () ->
        fields:
            simple:         @getSimpleFieldsForV1()
            complex:        @getComplexFieldsForV1()
        parameters:
            required:       @getRequiredFieldsName()
            optional:       @getOptionalFieldsName()
        aliases:            @getAliasesForV1()
        inverseAliases:     @getInverseAliasesForV1()
        primaryKeys:        @getPrimaryKeys()
        foreignKeys:        @getForeignKeys()
        inverseForeignKeys: @getInverseForeignKeys()
        uniqueIndexes:
            byColumnName:   @getUniqueIndexesByColumn()
            byIndexName:    @getUniqueIndexesByName()
        isView: @isView

module.exports = Table
