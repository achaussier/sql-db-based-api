'use strict'

###*
# @fileOverview Mocks used for unit tests
###

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
        redis: {}
        general:
            serverName: 'foo'
    database:
        mysql:
            poolCluster:
                end: ->
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
