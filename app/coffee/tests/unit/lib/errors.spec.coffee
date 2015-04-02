'use strict'

###*
# @fileOverview Tests about errors exports
###

###*
# Required packages
###
errorUtils  = require '../../../lib/errors.js'
should      = require 'should'

###*
# Declare variables
###
obj = undefined

describe 'Custom error classes export', ->

    it 'should exports all custom error classes', ->
        errorUtils.should.have.keys [
            'DatabaseError'
            'isCustomError'
            'isJsError'
            'ParameterError'
            'ServerError'
        ]

    describe 'isJsError', ->

        beforeEach (done) ->
            obj = null
            done()

        it 'should return true if JS error', ->
            obj = new Error 'foo'
            errorUtils.isJsError(obj).should.be.true

        it 'should return false if Custom error', ->
            obj = new errorUtils.ParameterError 'foo'
            errorUtils.isJsError(obj).should.be.false

        it 'should return false if empty param', ->
            errorUtils.isJsError().should.be.false

    describe 'isCustomError', ->

        beforeEach (done) ->
            obj = null
            done()

        it 'should return true if custom error', ->
            obj = new errorUtils.ParameterError 'foo'
            errorUtils.isCustomError(obj).should.be.true

        it 'should return true if custom error', ->
            obj = new errorUtils.ServerError 'foo'
            errorUtils.isCustomError(obj).should.be.true

        it 'should return true if custom error', ->
            obj = new errorUtils.DatabaseError 'foo'
            errorUtils.isCustomError(obj).should.be.true

        it 'should return false if js error', ->
            obj = new Error 'foo'
            errorUtils.isCustomError(obj).should.be.false

        it 'should return false if custom error', ->
            errorUtils.isCustomError().should.be.false
