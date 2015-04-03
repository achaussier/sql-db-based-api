'use strict'

###*
# @fileOverview Tests about Maria10Database class
###

###*
# Required custom classes
###
Maria10Database = require '../../../../lib/class/Maria10Database.js'

###*
# Required modules
###
clone       = require 'clone'
mocks       = require '../../_mocks.js'
apiErrors   = require '../../../../lib/errors.js'
sinon       = require 'sinon'
should      = require 'should'

###*
# Declare variables
###
maria10Database = undefined
mocksUtils      = undefined

describe 'Maria10Database class', ->

    beforeEach (done) ->
        maria10Database = null
        done()

    ###*
    # Check new instance create
    ###
    it 'should create new instance', ->
        maria10Database = new Maria10Database()
        maria10Database.should.be.instanceof Maria10Database
        maria10Database.should.have.keys [
            'clusterPool'
            'dbName'
            'readPool'
            'writePool'
        ]

    describe 'getDatabaseStructureQuery', ->
        beforeEach (done) ->
            maria10Database = new Maria10Database()
            done()

        ###*
        # Check without database information
        ###
        it 'should reject if no database configuration', ->
            maria10Database.getDatabaseStructureQuery()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with empty database name
        ###
        it 'should reject with empty database name', ->
            maria10Database.dbName = ''
            maria10Database.getDatabaseStructureQuery()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with valid database name
        ###
        it 'should resolve with valid database name', ->
            maria10Database.dbName = 'foo'
            maria10Database.getDatabaseStructureQuery()
                .then(
                    (result) ->
                        result.should.have.keys [
                            'sql'
                            'values'
                        ]
                        result.sql.length.should.be.above 0
                        result.values.should.be.instanceof Array
                        result.values.length.should.be.eql 0
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )
