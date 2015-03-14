'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/database.js'

# declare variables
val = undefined

describe 'Config : database', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'database'

        for key, value of configObj
            val = configObj[key].database({})
            Object.keys(val).length.should.be.above 0
        done()
