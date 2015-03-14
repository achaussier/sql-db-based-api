'use strict'

###*
# @fileOverview This file test the status action with fake api instance
###

should = require 'should'
actionheroPrototype = require('actionhero').actionheroPrototype
actionhero = new actionheroPrototype()
api = null

describe 'Helper : status action', ->

    before (done) ->
        actionhero.start (err, a) ->
            api = a
            done()

    after (done) ->
        actionhero.stop (err) ->
            done()

    it 'should display status of api', (done) ->
        api.specHelper.runAction 'status', (res, connection) ->
            res.should.have.properties [
                'id'
                'actionheroVersion'
                'uptime'
                'stats'
                'queues'
                'workers'
                'serverInformation'
            ]
            done()
