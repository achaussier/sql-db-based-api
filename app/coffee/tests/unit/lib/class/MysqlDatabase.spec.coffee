'use strict'

###*
# @fileOverview Tests about MysqlDatabase class
###

###*
# Required modules
###
clone           = require 'clone'
mocks           = require '../../_mocks.js'
mysql           = require 'mysql'
MysqlDatabase   = require '../../../../lib/class/MysqlDatabase.js'
apiErrors       = require '../../../../lib/errors.js'
sinon           = require 'sinon'
should          = require 'should'

###*
# Declare variables
###
databaseConfig  = undefined
mocksUtils      = clone mocks
myDb            = undefined
serverConfig    = undefined
stub            = undefined

describe 'MysqlDatabase', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        val         = undefined
        done()

    ###*
    # Check a new instance create
    ###
    it 'should return a new instance', ->
        val = new MysqlDatabase()
        val.should.be.instanceof MysqlDatabase

    describe 'checkServerConfiguration', ->

        beforeEach (done) ->
            myDb            = new MysqlDatabase()
            serverConfig    = mocksUtils.mysqlServerConfig
            done()

        ###*
        # With a good configuration
        ###
        it 'should return true', ->
            myDb.checkServerConfiguration(serverConfig).should.be.true

        ###*
        # Without server config
        ###
        it 'should return false', ->
            myDb.checkServerConfiguration(null).should.be.false

        ###*
        # With a bad host
        ###
        it 'should return false', ->
            serverConfig.host = ''
            myDb.checkServerConfiguration(serverConfig).should.be.false

        ###*
        # With a bad user
        ###
        it 'should return false', ->
            serverConfig.user = ''
            myDb.checkServerConfiguration(serverConfig).should.be.false

        ###*
        # With a bad password
        ###
        it 'should return false', ->
            serverConfig.password = ''
            myDb.checkServerConfiguration(serverConfig).should.be.false

        ###*
        # With a bad port
        ###
        it 'should return false', ->
            serverConfig.port = ''
            myDb.checkServerConfiguration(serverConfig).should.be.false

        ###*
        # With a bad multipleStatements
        ###
        it 'should return false', ->
            serverConfig.multipleStatements = ''
            myDb.checkServerConfiguration(serverConfig).should.be.false

    describe 'checkGeneratePoolsParams', ->

        beforeEach (done) ->
            databaseConfig  = mocksUtils.databaseConfig
            myDb            = new MysqlDatabase()
            serverConfig    = mocksUtils.mysqlServerConfig
            done()

        ###*
        # With no config
        ###
        it 'should return false', ->
            myDb.checkGeneratePoolsParams(null).should.be.false

        ###*
        # With good config without servers
        ###
        it 'should return true', ->
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.true

        ###*
        # With good config with master server
        ###
        it 'should return true', ->
            databaseConfig.masters.push serverConfig
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.true

        ###*
        # With good config with slave server
        ###
        it 'should return true', ->
            databaseConfig.slaves.push serverConfig
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.true

        ###*
        # With good config with slave and master servers
        ###
        it 'should return true', ->
            databaseConfig.masters.push serverConfig
            databaseConfig.slaves.push serverConfig
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.true

        ###*
        # With good config with bad master server
        ###
        it 'should return false', ->
            serverConfig.host = ''
            databaseConfig.masters.push serverConfig
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

        ###*
        # With a bad database
        ###
        it 'should return false', ->
            databaseConfig.dbName = ''
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

        ###*
        # With a bad dialect
        ###
        it 'should return false', ->
            databaseConfig.dialect = ''
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

        ###*
        # With bad selector
        ###
        it 'should return false', ->
            databaseConfig.selector = ''
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

        ###*
        # With bad masters
        ###
        it 'should return false', ->
            databaseConfig.masters = ''
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

        ###*
        # With bad slaves
        ###
        it 'should return false', ->
            databaseConfig.slaves = ''
            myDb.checkGeneratePoolsParams(databaseConfig).should.be.false

    describe 'generatePools', ->

        beforeEach (done) ->
            databaseConfig  = mocksUtils.databaseConfig
            myDb            = new MysqlDatabase()
            serverConfig    = mocksUtils.mysqlServerConfig
            stub            = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without config
        ###
        it 'should reject with no config', ->
            myDb.generatePools()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.instanceof apiErrors.ServerError
                )

        ###*
        # Simulate an error on mysql module
        ###
        it 'should reject if error', ->
            stub = sinon.stub(
                mysql,
                'createPoolCluster',
                ->
                    throw new Error 'unit-tests'
            )
            myDb.generatePools(databaseConfig)
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ServerError
                )
        ###*
        # Check without server
        ###
        it 'should resolve without server', ->
            myDb.generatePools(databaseConfig)
                .then(
                    (result) ->
                        should.not.exists(result)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with master server
        ###
        it 'should resolve with master server', ->
            databaseConfig.masters.push serverConfig
            myDb.generatePools(databaseConfig)
                .then(
                    (result) ->
                        should.not.exists(result)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
        ###*
        # Check with slave server
        ###
        it 'should resolve with slave server', ->
            databaseConfig.slaves.push serverConfig
            myDb.generatePools(databaseConfig)
                .then(
                    (result) ->
                        should.not.exists(result)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with master and slave servers
        ###
        it 'should resolve withmaster and slave servers', ->
            databaseConfig.masters.push serverConfig
            databaseConfig.slaves.push serverConfig
            myDb.generatePools(databaseConfig)
                .then(
                    (result) ->
                        should.not.exists(result)
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getReadConnection', ->

        beforeEach (done) ->
            databaseConfig  = mocksUtils.databaseConfig
            myDb            = new MysqlDatabase()
            myDb.generatePools(databaseConfig)
            stub            = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without readPool attribute
        ###
        it 'should reject if no readPool', ->
            myDb.readPool = null
            myDb.getReadConnection()
                .then(
                    (roConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ServerError
                )

        ###*
        # Simulate an error return by getConnection method
        ###
        it 'should reject if error occurs', ->
            stub = sinon.stub(
                myDb.readPool,
                'getConnection',
                (callback) ->
                    callback 'unit-tests', null
            )
            myDb.getReadConnection()
                .then(
                    (roConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.eql 'unit-tests'
                )

        ###*
        # Check with all OK
        ###
        it 'should return a connection if no error occurs', ->
            stub = sinon.stub(
                myDb.readPool,
                'getConnection',
                (callback) ->
                    callback null, 'unit-tests'
            )
            myDb.getReadConnection()
                .then(
                    (roConnection) ->
                        roConnection.should.be.eql 'unit-tests'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getWriteConnection', ->

        beforeEach (done) ->
            databaseConfig  = mocksUtils.databaseConfig
            myDb            = new MysqlDatabase()
            myDb.generatePools(databaseConfig)
            stub            = null
            done()

        afterEach (done) ->
            stub.restore() if stub?.restore?
            done()

        ###*
        # Check without writePool attribute
        ###
        it 'should reject if no writePool', ->
            myDb.writePool = null
            myDb.getWriteConnection()
                .then(
                    (roConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ServerError
                )

        ###*
        # Simulate an error return by getConnection method
        ###
        it 'should reject if error occurs', ->
            stub = sinon.stub(
                myDb.writePool,
                'getConnection',
                (callback) ->
                    callback 'unit-tests', null
            )
            myDb.getWriteConnection()
                .then(
                    (roConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.eql 'unit-tests'
                )

        ###*
        # Check with all OK
        ###
        it 'should return a connection if no error occurs', ->
            stub = sinon.stub(
                myDb.writePool,
                'getConnection',
                (callback) ->
                    callback null, 'unit-tests'
            )
            myDb.getWriteConnection()
                .then(
                    (roConnection) ->
                        roConnection.should.be.eql 'unit-tests'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
    describe 'executeSelect', ->

        beforeEach (done) ->
            databaseConfig  = mocksUtils.databaseConfig
            myDb            = new MysqlDatabase()
            myDb.generatePools(databaseConfig)
            done()

        ###*
        # Check with bad sql connection param
        ###
        for badConnection in mocksUtils.badSqlConnections
            do (badConnection) ->
                it 'should return ParameterError if connection param is invalid', ->
                    myDb.executeSelect badConnection, {}
                        .then(
                            (dbResults, fields) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof apiErrors.ParameterError
                        )

        ###*
        # Check with bad sql queryData param
        ###
        for badQueryData in mocksUtils.badQueryDatas
            do (badQueryData) ->
                it 'should return ParameterError if queryData param is invalid', ->
                    myDb.executeSelect mocksUtils.sqlConnection, badQueryData
                        .then(
                            (dbResults, fields) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof apiErrors.ParameterError
                        )

        ###*
        # Simulate an error return by getConnection method
        ###
        it 'should return DatabaseError if query return an error', ->
            myDb.executeSelect mocksUtils.sqlConnectionWithQueryError, mocksUtils.sqlQueryData
                .then(
                    (dbResults) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.DatabaseError
                )

        ###*
        # Check with all OK
        ###
        it 'should execute query if params are valid', ->
            myDb.executeSelect mocksUtils.sqlConnection, mocksUtils.sqlQueryData
                .then(
                    (dbResults) ->
                        dbResults.should.be.instanceof Object
                        dbResults.should.have.keys [
                            'results'
                            'fields'
                        ]
                        dbResults.results.should.be.instanceof Array
                        dbResults.fields.should.be.instanceof Array
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
