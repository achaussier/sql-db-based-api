'use strict'

###*
# @fileOverview Tests about database structure initializer
###

###*
# Requires modules
###
apiErrors       = require '../../../../lib/errors.js'
clone           = require 'clone'
dbStructUtils   = require '../../../../lib/databaseStructure.js'
initializer     = require '../../../../initializers/ini/databaseStructure.js'
mocks           = require '../../_mocks.js'
mysql           = require 'mysql'
Q               = require 'q'
should          = require 'should'
sinon           = require 'sinon'

###*
# Declare variables
###
cb          = undefined
mocksUtils  = undefined
spy         = undefined
stub        = undefined
stub2       = undefined
val         = undefined


describe 'Initializer : databaseStructure', ->

    beforeEach (done) ->
        cb          = sinon.spy()
        mocksUtils  = clone mocks
        val         = null
        spy         = null
        stub        = null
        stub2       = null
        done()

    afterEach (done) ->
        stub.restore()  if stub?
        stub2.restore() if stub2?
        done()

    ###*
    # Check with namespace
    ###
    it 'should continue', ->
        val = { dbStructure: {} }
        initializer.initialize(
            val,
            cb
        )
        cb.calledOnce.should.be.true
        val.should.have.keys 'dbStructure'
        val.dbStructure.should.have.keys [
            'data'
            'versionOneRender'
        ]

    ###*
    # Check without namespace
    ###
    it 'should continue', ->
        val = {}
        initializer.initialize(
            val,
            cb
        )
        cb.calledOnce.should.be.true
        val.should.have.keys 'dbStructure'
        val.dbStructure.should.have.keys [
            'data'
            'versionOneRender'
        ]

    ###*
    # Check without database managed
    ###
    it 'should skip if no database managed', ->
        delete mocksUtils.api.database
        initializer.start(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.be.true
        should.not.exists cb.args[0][0]

    ###*
    # Check start method of initializer
    ###
    it 'should execute start method', ->
        mocksUtils.api.dbStructure =
                data: {}
                versionOneRender: {}

        stub = sinon.stub(
            dbStructUtils,
            'getStructureFromDB',
            () ->
                Q.fcall ->
                    []
        )
        stub2 = sinon.stub(
            dbStructUtils,
            'processDatabaseStructureParts',
            () ->
                Q.fcall ->
                    {
                        versionOneRender: -> { foo: 'bar' }
                    }
        )

        initializer
            .start mocksUtils.api, cb
            .then ()->
                cb.called.should.be.true
                should.not.exists cb.args[0][0]

    ###*
    # Check with an error on getStructureFromDB method
    ###
    it 'should reject if getStructureFromDB has an error', ->
        mocksUtils.api.dbStructure =
            data: {}
            versionOneRender: {}

        stub = sinon.stub(
            dbStructUtils,
            'getStructureFromDB',
            () ->
                Q.fcall ->
                    throw new Error 'test-getStructureFromDB-error'
        )

        initializer
            .start mocksUtils.api, cb
            .then () ->
                cb.called.should.be.true
                cb.args[0][0].should.be.instanceof Error
                cb.args[0][0].message.should.be.eql 'test-getStructureFromDB-error'

    ###*
    # Check with an error on processDatabaseStructureParts method
    ###
    it 'should reject if processDatabaseStructureParts has an error', ->
        mocksUtils.api.dbStructure =
            data: {}
            versionOneRender: {}

        stub = sinon.stub(
            dbStructUtils,
            'getStructureFromDB',
            () ->
                Q.fcall ->

        )
        stub2 = sinon.stub(
            dbStructUtils,
            'processDatabaseStructureParts',
            () ->
                Q.fcall ->
                    throw new Error 'test-processDatabaseStructureParts-error'
        )

        initializer
            .start mocksUtils.api, cb
            .then () ->
                cb.called.should.be.true
                cb.args[0][0].should.be.instanceof Error
                cb.args[0][0].message.should.be.eql 'test-processDatabaseStructureParts-error'

    ###*
    # Check stop method of initializer
    ###
    it 'should do nothing when api stopping', ->
        initializer.stop(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.true
