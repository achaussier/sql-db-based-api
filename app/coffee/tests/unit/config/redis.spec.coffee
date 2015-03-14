'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/redis.js'

# declare variables
val = undefined

describe 'Config : redis', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'redis'

        for key, value of configObj
            val = configObj[key].redis({})
            Object.keys(val).length.should.be.above 0
        done()
