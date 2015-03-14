'use strict'

# require packages
should = require 'should'
configObj = require '../../../../config/servers/socket.js'

# declare variables
val = undefined

describe 'Config : socket server', ->

    beforeEach (done) ->
        val = undefined
        done()

    it 'should be loaded', (done) ->
        configObj.should.be.have.properties 'default'
        configObj['default'].should.be.have.keys 'servers'
        configObj['default'].servers.should.be.have.keys 'socket'

        for key, value of configObj
            val = configObj[key].servers.socket {}
            Object.keys(val).length.should.be.above 0
        done()
