'use strict'

###*
# @fileOverview Mocks used for unit tests
###

noop = ()->

exports.noop = noop

exports.api =
    actionheroVersion: 'foo'
    id: 'bar'
    config:
        redis: {}
        general:
            serverName: 'foo'
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

exports.connection =
    response:
        id: null
        actionheroVersion: null
        stats: null
        queues: null
        workers: null

exports.winston =
    transports:
        Console: () ->
