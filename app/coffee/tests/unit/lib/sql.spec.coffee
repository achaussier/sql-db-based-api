'use strict'

###*
# @fileOverview Tests about sql functions
###

# require packages
clone       = require 'clone'
sqlUtils    = require '../../../lib/sql.js'
rmErrors    = require '../../../lib/errors.js'
mocks       = require '../_mocks.js'
should      = require 'should'

mocksUtils = clone mocks

describe 'SQL functions', ->

    beforeEach (done) ->
        mocksUtils  = clone mocks
        val         = undefined
        done()

    describe 'getReadOnlyConnection', ->

        beforeEach (done) ->
            mocksUtils  = clone mocks
            val         = undefined
            done()

        for badApi in mocksUtils.badSqlApis
            do (badApi) ->
                it 'should throw if bad api param', ->
                    sqlUtils.getReadOnlyConnection badApi
                        .then(
                            (roConnection) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should return a connection if connection error occurs', ->
            mocksUtils.api.database.mysql.readPool.getConnection = (callback) ->
                callback('foo', null)

            sqlUtils.getReadOnlyConnection mocksUtils.api
                .then(
                    (roConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should return a connection if no error occurs', ->
            sqlUtils.getReadOnlyConnection mocksUtils.api
                .then(
                    (roConnection) ->
                        roConnection.should.be.instanceof Object
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'getWriteConnection', ->

        for badApi in mocksUtils.badSqlApis
            do (badApi) ->
                it 'should throw if bad api param', ->
                    sqlUtils.getWriteConnection badApi
                        .then(
                            (writeConnection) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should return a connection if connection error occurs', ->
            mocksUtils.api.database.mysql.writePool.getConnection = (callback) ->
                callback('foo', null)

            sqlUtils.getWriteConnection mocksUtils.api
                .then(
                    (writeConnection) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should return a connection if no error occurs', ->
            sqlUtils.getWriteConnection mocksUtils.api
                .then(
                    (writeConnection) ->
                        writeConnection.should.be.instanceof Object
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'executeSelect', ->

        beforeEach (done) ->
            mocksUtils = clone mocks
            val = undefined
            done()

        for badConnection in mocksUtils.badSqlConnections
            do (badConnection) ->
                it 'should return ParameterError if connection param is invalid', ->
                    sqlUtils.executeSelect badConnection, {}
                        .then(
                            (dbResults, fields) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        for badQueryData in mocksUtils.badQueryDatas
            do (badQueryData) ->
                it 'should return ParameterError if queryData param is invalid', ->
                    sqlUtils.executeSelect mocksUtils.sqlConnection, badQueryData
                        .then(
                            (dbResults, fields) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should return DatabaseError if query return an error', ->
            sqlUtils.executeSelect mocksUtils.sqlConnectionWithQueryError, mocksUtils.sqlQueryData
                .then(
                    (dbResults) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.DatabaseError
                )

        it 'should execute query if params are valid', ->
            sqlUtils.executeSelect mocksUtils.sqlConnection, mocksUtils.sqlQueryData
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
