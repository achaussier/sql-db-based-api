'use strict'

###*
# @fileOverview Tests about generateGetStructure pre processor
###

###*
# Required modules
###
clone           = require 'clone'
mocks           = require '../../_mocks.js'
preProcessor    = require '../../../../initializers/pre/generateGetStructure.js'
should          = require 'should'
sinon           = require 'sinon'

###*
# Declare variables
###
cb          = undefined
mocksUtils  = undefined

describe 'Pre processor : generateGetStructure', ->

    beforeEach (done) ->
        cb          = sinon.spy()
        mocksUtils  = clone mocks
        done()

    ###*
    # Check load
    ###
    it 'should be load', ->
        preProcessor.initialize mocksUtils.api, cb
        cb.calledOnce.should.be.true

    ###*
    # Check main fuction
    ###
    it 'should return true', ->
        preProcessor.generateGetStructure(
            mocksUtils.connectionWithErrorArray,
            {},
            cb
        )
        cb.calledOnce.should.be.true
        cb.args[0][1].should.be.true
