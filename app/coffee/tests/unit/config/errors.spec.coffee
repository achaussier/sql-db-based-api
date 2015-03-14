'use strict'

# require packages
should = require 'should'
configObj = require '../../../config/errors.js'

# declare variables
val = undefined

describe 'Config : errors', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'errors'

        for key, value of configObj
            val = configObj[key].errors({})

            for errName, errVal of val
                errVal(['foo']).should.be.instanceof String if typeof errVal is 'function'
        done()
