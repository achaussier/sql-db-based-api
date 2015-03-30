'use strict'

###*
# @fileOverview Tests about database structure initializer
###

# require packages
dbStructUtils   = require '../../../../lib/databaseStructure.js'
initializer     = require '../../../../initializers/ini/databaseStructure.js'
rmErrors        = require '../../../../lib/errors.js'
mocks           = require '../../_mocks.js'
should          = require 'should'
sinon           = require 'sinon'
clone           = require 'clone'
mysql           = require 'mysql'

cb          = null
mocksUtils  = undefined
Q           = require 'q'
spy         = null
stub        = null
stub2       = null
val         = null


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

    it 'should do nothing when api stopping', ->
        initializer.stop(
            mocksUtils.api,
            cb
        )
        cb.calledOnce.should.true
