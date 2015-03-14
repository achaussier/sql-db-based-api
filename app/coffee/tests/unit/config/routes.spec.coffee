'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/routes.js'

# declare variables
val = undefined

describe 'Config : routes', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'routes'

        for key, value of configObj
            val = configObj[key].routes({})
            Object.keys(val).length.should.be.above 0
        done()
