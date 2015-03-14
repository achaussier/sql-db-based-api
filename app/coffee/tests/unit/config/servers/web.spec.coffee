'use strict'

# require packages
should = require 'should'
configObj = require '../../../../config/servers/web.js'
mocks = require '../../_mocks.js'

# declare variables
mocksUtils = undefined
val = undefined

describe 'Config : web server', ->

    beforeEach (done) ->
        mocksUtils = Object.create mocks
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'servers'
        configObj['default'].servers.should.be.have.keys 'web'

        for key, value of configObj
            val = configObj[key].servers.web mocksUtils.api
            Object.keys(val).length.should.be.above 0
        done()
