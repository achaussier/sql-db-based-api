'use strict'

# require packages
should      = require 'should'
configObj   = require '../../../config/database.js'

# declare variables
val = undefined

describe 'Config : database', ->

    beforeEach (done) ->
        val = undefined
        done()

    ###*
    # Check loading config
    ###
    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'database'

        for key, value of configObj
            val = configObj[key].database({})
            Object.keys(val).length.should.be.above 0
        done()

    ###*
    # Check if no environment variables
    ###
    it 'should be loaded without env variables', (done) ->
        envBackup =
            dbName  : process.env.API_CONF_DB_NAME
            host    : process.env.API_CONF_DB_HOST
            user    : process.env.API_CONF_DB_USER
            pass    : process.env.API_CONF_DB_PASSWORD
            port    : process.env.API_CONF_DB_PORT

        delete process.env.API_CONF_DB_HOST
        delete process.env.API_CONF_DB_USER
        delete process.env.API_CONF_DB_PASSWORD
        delete process.env.API_CONF_DB_PORT
        delete process.env.API_CONF_DB_NAME

        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'database'

        for key, value of configObj
            val = configObj[key].database({})
            Object.keys(val).length.should.be.above 0

        process.env.API_CONF_DB_NAME        = envBackup.dbName
        process.env.API_CONF_DB_HOST        = envBackup.host
        process.env.API_CONF_DB_USER        = envBackup.user
        process.env.API_CONF_DB_PASSWORD    = envBackup.pass
        process.env.API_CONF_DB_PORT        = envBackup.port
        done()
