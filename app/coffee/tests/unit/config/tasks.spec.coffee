'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/tasks.js'
mocks = require '../_mocks.js'

# declare variables
mocksUtils = undefined
val = undefined
val2 = undefined

describe 'Config : tasks', ->

    beforeEach (done) ->
        mocksUtils = Object.create mocks
        val = undefined
        val2 = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'tasks'

        for key, value of configObj
            val = configObj[key].tasks {}
            val2 = configObj[key].tasks mocksUtils.api
            Object.keys(val).length.should.be.above 0
        done()
