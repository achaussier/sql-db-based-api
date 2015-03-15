'use strict'

###*
# @fileOverview Tests about mysql initializer
###

# require packages
initializer = require '../../../../initializers/ini/mysql.js'
rmErrors = require '../../../../lib/errors.js'
mocks = require '../../_mocks.js'
should = require 'should'
sinon = require 'sinon'
clone = require 'clone'
mysql = require 'mysql'

cb = null
mocksUtils = undefined
spy = null
stub = null
val = null


describe 'Initializer : mysql', ->

    beforeEach (done) ->
        cb = sinon.spy()
        mocksUtils = clone mocks
        val = null
        spy = null
        stub = null
        done()

    it 'should create database namespace', ->
        initializer.initialize(
            {},
            cb
        )
        cb.calledOnce.should.be.true
        val = mocksUtils.api.database?.mysql?
        val.should.be.true

    it 'should create mysql namespace', ->
        initializer.initialize(
            {
                database: {}
            },
            cb
        )
        cb.calledOnce.should.be.true
        val = mocksUtils.api.database?.mysql?
        val.should.be.true

    it 'should return error if connection is not possible', ->
        delete mocksUtils.api.config.database
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][0].should.be.instanceof rmErrors.ServerError

    it 'should build pools if connection to server is ok', ->
        stub = sinon.stub(
            mysql,
            'createPoolCluster',
            () ->
                {
                    add: ->
                    of: ->
                }
        )
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists(cb.args[0][0])
        mysql.createPoolCluster.restore()

    it 'should disconnect from servers when api stopping', ->
        spy = sinon.spy()
        mocksUtils.api.database.mysql.poolCluster.end = spy
        initializer.stop(
            mocksUtils.api,
            cb
        )
        spy.calledOnce.should.true
        cb.calledOnce.should.true
