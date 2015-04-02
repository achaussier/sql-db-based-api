'use strict'

###*
# @fileOverview Tests about mysql initializer
###

###*
# Required modules
###
apiErrors       = require '../../../../lib/errors.js'
clone           = require 'clone'
initializer     = require '../../../../initializers/ini/mysql.js'
mocks           = require '../../_mocks.js'
mysql           = require 'mysql'
sinon           = require 'sinon'
should          = require 'should'

###*
# Declare variables
###
cb          = undefined
mocksUtils  = undefined
spy         = undefined
stub        = undefined
val         = undefined


describe 'Initializer : mysql', ->

    beforeEach (done) ->
        cb          = sinon.spy()
        mocksUtils  = clone mocks
        spy         = null
        stub        = null
        val         = null
        done()

    afterEach (done) ->
        stub.restore() if stub?.restore?
        done()

    ###*
    # Check initialize section
    ###
    it 'should create database namespace if not exists', ->
        initializer.initialize(
            {},
            cb
        )
        cb.calledOnce.should.be.true
        val = mocksUtils.api.database?
        val.should.be.true

    ###*
    # Check initialize section
    ###
    it 'should continue if namespace exists', ->
        initializer.initialize(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        val = mocksUtils.api.database?
        val.should.be.true

    ###*
    # Check without database config (initailizer should be skip)
    ###
    it 'should be skipped if no database config', ->
        initializer.start(
            null,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]

    ###*
    # Check without database config (initailizer should be skip)
    ###
    it 'should be skipped if no database config', ->
        mocksUtils.api.config = null
        delete mocksUtils.api.database
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]
        should.not.exists mocksUtils.api.database

    ###*
    # Check without database config (initailizer should be skip)
    ###
    it 'should be skipped if no database config', ->
        mocksUtils.api.config.database = null
        delete mocksUtils.api.database
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]
        should.not.exists mocksUtils.api.database

    ###*
    # Check without database config (initailizer should be skip)
    ###
    it 'should be skipped if no database config', ->
        mocksUtils.api.config.database.dialect = null
        delete mocksUtils.api.database
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]
        should.not.exists mocksUtils.api.database

    ###*
    # Check without manage database config (initailizer should be skip)
    ###
    it 'should be skipped if no managed database', ->
        mocksUtils.api.config.database.dialect  = 'foo'
        mocksUtils.api.database                 = null
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]
        should.not.exists mocksUtils.api.database

    ###*
    # Check with a bad mysql version
    ###
    it 'should reject if not managed mysql db version', ->
        mocksUtils.api.config.database.dialect = 'maria1'
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
        should.exists(cb.args[0][0])

    ###*
    # Check with a good configuration
    ###
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

    ###*
    # Check with maria10 dialect
    ###
    it 'should build pools if maria10 dialect', ->
        mocksUtils.api.config.database.dialect = 'maria10'
        stub = sinon.stub(
            mysql,
            'createPoolCluster',
            ->
                {
                    add: ->
                    of: ->
                }
        )
        initializer
            .start(
                mocksUtils.api,
                cb
            )
            .then(
                (result) ->
                    cb.calledOnce.should.be.true
                    should.not.exists(cb.args[0][0])
                ,(error) ->
                    throw new Error 'Should not be go here in this test'
            )


    ###*
    # Check with a bad config
    ###
    it 'should call callback with an error if error occurs during processing', ->
        mocksUtils.api.config.database.dialect = 'maria10'
        mocksUtils.api.config.database.masters = null
        initializer
            .start(
                mocksUtils.api,
                cb
            )
            .then(
                (result) ->
                    cb.calledOnce.should.be.true
                    should.exists(cb.args[0][0])
                ,(error) ->
                    throw new Error 'Should not be go here in this test'
            )
    ###*
    # End check with database managed
    ###
    it 'should disconnect from servers when api stopping', ->
        spy = sinon.spy()
        mocksUtils.api.database.end = spy
        initializer.stop(
            mocksUtils.api,
            cb
        )
        spy.calledOnce.should.true
        cb.calledOnce.should.true

    ###*
    # End check without database
    ###
    it 'should do nothing if no db', ->
        mocksUtils.api.database = null
        initializer.stop(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.true

    ###*
    # End check without database
    ###
    it 'should do nothing if no db', ->
        mocksUtils.api.database.end = null
        initializer.stop(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.true
