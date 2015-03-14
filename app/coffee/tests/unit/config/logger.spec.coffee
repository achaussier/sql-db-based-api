'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/logger.js'
mocks = require '../_mocks.js'

# declare variables
mocksUtils = undefined
val = undefined

describe 'Config : logger', ->

    beforeEach (done) ->
        val = undefined
        mocksUtils = Object.create mocks
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'logger'

        for key, value of configObj
            val = configObj[key].logger({})
            Object.keys(val).length.should.be.above 0

            for transport in val.transports
                transport mocksUtils.api, mocksUtils.winston
        done()
