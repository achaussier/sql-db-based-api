'use strict'

###*
# @fileOverview Tests about sql functions
###

# require packages
clone = require 'clone'
sqlUtils = require '../../../lib/sql.js'
rmErrors = require '../../../lib/errors.js'
mocks = require '../_mocks.js'
should = require 'should'

mocksUtils = null

badApis = [
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
describe 'SQL functions', ->

    beforeEach (done) ->
        mocksUtils = clone mocks
        val = undefined
        done()

    describe 'getReadOnlyConnection', ->

        for badApi in badApis
            do ->
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

        for badApi in badApis
            do ->
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
