'use strict'

###*
# @fileOverview Mocks used for unit tests
###

Q = require 'q'
rmErrors = require '../../lib/errors.js'

noop = ()->

###*
# A simple function mock
###
exports.noop = noop

###*
# An api mock
###
exports.api =
    actions:
        addPostProcessor: (postProcessor) ->
    actionheroVersion: 'foo'
    id: 'bar'
    config:
        database:
            database: 'foo'
        redis: {}
        general:
            serverName: 'foo'
    database:
        mysql:
            poolCluster:
                end: ->
            readPool:
                getConnection: (cb) ->
                    cb null, {}
            writePool:
                getConnection: (cb) ->
                    cb null, {}

    stats:
        getAll: (cb) ->
            cb null, { 'foo': 'bar'}
    tasks:
        details: (cb) ->
            cb null, {
                queues: 'foo'
                workers: 'bar'
            }
    utils:
        sqlDateTime: null

###*
# A common connection mock
###
exports.connection =
    response:
        id: null
        actionheroVersion: null
        stats: null
        queues: null
        workers: null

###*
# A connection with error array mock
###
exports.connectionWithErrorArray =
    rawConnection: {}
    error: [
        {
            code: 666
        }
    ]

###*
# A winston module mock
###
exports.winston =
    transports:
        Console: () ->

###*
# Bad sql api objects
###
exports.badSqlApis = [
    {},
    {
        database: null
    },
    {
        database:
            mysql: null
    },
    {
        database:
            mysql:
                readPool: null
                writePool: null
    }
]

###*
# Bad sql connections
###
exports.badSqlConnections = [
    {},
    {
        query: null
    }
]

###*
# Good sql connection
###
exports.sqlConnection =
    query: (query, cb) ->
        cb(
            null,
            [],
            []
        )

###*
# sql query return an error
###
exports.sqlConnectionWithQueryError =
    query: (query, cb) ->
        cb(
            'foo',
            null,
            null
        )

###*
# Bad query data
###
exports.badQueryDatas = [
    {},
    {
        sql: null
    },
    {
        sql: ''
    },
    {
        sql: 'foo'
    },
    {
        sql: 'foo'
        values: null
    }
]

###*
# Good query data
###
exports.sqlQueryData =
    sql: 'foo'
    values: []

###*
# A promise which reject DatabaseError
###
exports.rejectDatabaseError = ->
    Q.fcall ->
        throw new rmErrors.DatabaseError(null, null)

###*
# A promise which reject ParameterError
###
exports.rejectParameterError = ->
    Q.fcall ->
        throw new rmErrors.ParameterError(null, null)

###*
# A fake mysql result for db structure requests
###
exports.fakeDbStructureResultsFromDB = ->
    Q.fcall ->
        results: [
            {TABLE_NAME: 'foo'}
            {TABLE_NAME: 'bar'}
        ],
        fields: [
            {}
        ]

###*
# A fake mysql connection
###
exports.fakeSqlConnection = ->
    Q.fcall ->
        release: ->

###*
# Bad values for an object check
###
exports.badObjectParam = [
    'foo'
    []
    ->
    null
]

###*
# Bad values for an array check
###
exports.badArrayParam = [
    'foo'
    {}
    ->
    null
    undefined
]

###*
# Bad values for a non empty string check
###
exports.badNotEmptyStringParam = [
    ''
    {}
    ->
    null
    undefined
]

###*
# Fake database structure field
###
exports.dbStructureField =
    tableSchema        : 'foobar'
    tableName          : 'foo'
    columnName         : 'bar'
    ordinalPosition    : null
    defaultValue       : null
    isNullable         : null
    dataType           : 'int'
    charMaxLength      : 255
    charOctetLength    : null
    numPrecision       : 11
    numScale           : null
    datetimePrecision  : null
    charSetName        : null
    collationName      : null
    columnType         : null
    columnKey          : 'foo'
    extra              : ''
    refTableName       : null
    refColumnName      : null
    tableType          : 'view'
    uniqueIndexName    : null

###*
# Fake database structure unique index
###
exports.dbStructureUniqueIndex =
    indexName   : 'foo'
    tableName   : 'bar'
    columnName  : 'foobar'

###*
# Fake database structure unique index
###
exports.dbStructureTable =
    name: 'foo'

###*
# Fake database structure unique index
###
exports.dbStructureRelation=
    originColumn: 'foo'
    destTable: 'bar'
    destColumn: 'foobar'
