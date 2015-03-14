'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/stats.js'

# declare variables
val = undefined

describe 'Config : stats', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'stats'

        for key, value of configObj
            val = configObj[key].stats {}
            Object.keys(val).length.should.be.above 0

        done()
