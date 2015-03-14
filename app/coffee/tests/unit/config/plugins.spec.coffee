'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/plugins.js'

# declare variables
val = undefined

describe 'Config : plugins', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'general'

        for key, value of configObj
            val = configObj[key].general({})
            Object.keys(val).length.should.be.above 0
        done()
