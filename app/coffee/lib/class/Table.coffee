'use strict'

###*
# @fileOverview Tables objects used to build database structure
###

ComplexField    = require './ComplexField.js'
SimpleField     = require './SimpleField.js'
UniqueIndex     = require './UniqueIndex.js'
isArray         = require('util').isArray

class Table

    ###*
    # Constructor used to create new Table object
    # @param    {Object}    tableData   Table data used to build object
    # @return   {Object}                Table instance of Table
    ###
    constructor: (tableData) ->
        @name           = tableData.name
        @fields         = []
        @uniqueIndexes  = []
        @relations      = []
        @isView         = tableData.isView or false

    ###*
    # Add a new field if not already exists
    # @param    {Object}    field   Field to add
    # @return   {Boolean}           True if field added, else false
    ###
    addField: (field) ->
        if @containsField(field.columnName)
            false
        else
            @fields.push field
            true

    ###*
    # Add a new relation if not already exists
    # @param    {Object}    relationToAdd   Relation to add
    # @return   {Boolean}                   True if relation added, else false
    ###
    addRelation: (relationToAdd) ->
        relation = []

        ###*
        # Search if relation already exists
        ###
        relation.push rel for rel in @relations when (
            rel.originColumn    is relationToAdd.originColumn and
            rel.destTable       is relationToAdd.destTable and
            rel.destColumn      is relationToAdd.destColumn
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
    # Add a new unique index or update it
    # @param    {Object}    indexPart   Field to add
    # @return   {Boolean}               True if field added, else false
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
            indexes[0].addColumn indexPart.columnName

    ###*
    # Check if this table contains a field where name equal to param
    # @param    {String}    fieldName   Requested name
    # @return   {Boolean}               True if field exists
    ###
    containsField: (fieldName) ->
        match = []
        match.push field for field in @fields when field.columnName is fieldName

        match.length > 0

    ###*
    # Return field if exists or null
    # @param    {String}        fieldName   Requested name
    # @return   {Object|null}               True if field exists
    ###
    getField: (fieldName) ->
        match = []
        match.push field for field in @fields when field.columnName is fieldName

        match[0] or null

    ###*
    # To populate versionOneRender object
    # @return   {Object}    Simple fields for versionOneRender
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
    # @return   {Object}    Complex fields for versionOneRender
    # @todo Delete this method when v1 of database structure cease to be used
    ###
    getComplexFieldsForV1: () ->

        render = {}

        ###*
        # Get all fields which match fk complex object specification of v1
        ###
        fkFields = []
        fkFields.push field for field in @fields when field.refTableName?

        ###*
        # For each fk field, create a ComplexField object to render it for v1
        ###
        for fkField in fkFields
            do (fkField) ->
                obj =
                    refTableName: fkField.refTableName
                    isArray: false
                    isNullable: fkField.isNullable()
                render[fkField.columnName] = new ComplexField(obj, false)

        ###*
        # Get all fields which match fk complex object specification of v1
        ###
        invRels = []
        invRels.push rel for rel in @relations when rel.isInverse

        ###*
        # For each fk field, create a ComplexField object to render it for v1
        ###
        for invRel in invRels
            do (invRel) ->
                obj =
                    refTableName: invRel.destTable
                    isArray: true
                    isNullable: true
                render[invRel.destTable] = new ComplexField(obj)

        render

    ###*
    # Return required fields for this table
    # @return   {Array}     Array with all required fields name
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
    # @return   {Array}     Array with all optional fields name
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
    # @return   {Object}    Object with all aliases
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
    # @return   {Array}     Array with all inverse aliases
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
    # @return   {Array}     Array with all primary keys name
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
    # @return   {Array}     Array with all foreign keys name
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
    # @return   {Array}     Array with all inverse foreign keys name
    ###
    getInverseForeignKeys: () ->

        ###*
        # Get all destTable which are inverse relations
        ###
        invForeignKeys = []
        invForeignKeys.push rel.destTable for rel in @relations when (
            rel.isInverse is true
        )

        invForeignKeys

    ###*
    # Return inverse foreign key for this table and this dest table
    # @param    {String}    Dest table name of relation to return
    # @return   {Object}    Relation object match destination table name param
    ###
    getInverseForeignKey: (tableName) ->

        ###*
        # Get relation match
        ###
        invForeignKeys = []
        invForeignKeys.push rel.destTable for rel in @relations when (
            rel.isInverse is true and rel.destTable = tableName
        )

        invForeignKeys[0] if invForeignKeys.length isnt 0

    ###*
    # Check if a field is a foreign key
    # @param    {String}    fieldName   Field to test
    # @return   {Boolean}               True if field is foreign key, else false
    ###
    isForeignKey: (field) ->
        foreignKeys = @getForeignKeys()
        foreignKeys.indexOf(field) isnt -1

    ###*
    # Check if a field is an inverse foreign key
    # @param    {String}    fieldName   Field to test
    # @return   {Boolean}               True if field is a inverse foreign key
    ###
    isInverseForeignKey: (tableName) ->
        inverseForeignKeys = @getInverseForeignKeys()
        inverseForeignKeys.indexOf(tableName) isnt -1

    ###*
    # Check if a field is an inverse relation or a foreign key
    # @param    {String}    field   Table to test
    # @return   {Boolean}           True if relation exists, else false
    ###
    isRelationExists: (field) ->
        @isForeignKey(field) or @isInverseForeignKey(field)

    ###*
    # Return unique indexes by columnName for this table
    # @return   {Object}    Object with all unique indexes
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
    # @return   {Object}    Object with all unique indexes
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
    # @return   {Object}    An object same as v1 database structure
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
