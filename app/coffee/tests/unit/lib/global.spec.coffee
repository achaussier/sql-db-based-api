'use strict'

###*
# @fileOverview Unit tests for global lib
###

# require packages
clone = require 'clone'
should = require 'should'
globalUtils = require '../../../lib/global.js'
mocks = require '../_mocks.js'
rmErrors = require '../../../lib/errors.js'

# declare variables
badObj = undefined
mocksUtils = clone mocks
val = undefined

describe 'Global lib', ->

    describe 'checkKeysHaveNotNullValues', ->

        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        it 'should reject if no param', ->
            globalUtils.checkKeysHaveNotNullValues()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->

                it 'should reject if bad obj param', ->
                    globalUtils.checkKeysHaveNotNullValues badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        for badArray in mocksUtils.badArrayParam
            do (badArray) ->
                it 'should reject if bad array param', ->
                    obj =
                        foo: 'bar'
                    globalUtils.checkKeysHaveNotNullValues obj, badArray
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should resolve false if some keys not exists', ->
            obj =
                foo: 'bar'
            arr = [ 'bar' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        result.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should resolve false if some keys have null value', ->
            obj =
                foo: null
            arr = [ 'foo' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        result.should.be.false
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        it 'should resolve true if some keys have null value', ->
            obj =
                foo: 'bar'
            arr = [ 'foo' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        result.should.be.true
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'isNotEmptyString', ->

        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        it 'should return false if no param', ->
            val = globalUtils.isNotEmptyString()
            val.should.be.false

        for badString in mocksUtils.badNotEmptyStringParam
            do (badString) ->
                it 'should return false if bad string param', ->
                    val = globalUtils.isNotEmptyString badString
                    val.should.be.false

        it 'should return true if not empty string param', ->
            val = globalUtils.isNotEmptyString 'foo'
            val.should.be.true

    describe 'areSameArrays', ->
        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        it 'should return false if no param', ->
            val = globalUtils.areSameArrays()
            val.should.be.false

        for badArray in mocksUtils.badArrayParam
            do (badArray) ->
                it 'should return false if bad first param', ->
                    val = globalUtils.areSameArrays(badArray, [])
                    val.should.be.false

        for badArray in mocksUtils.badArrayParam
            do (badArray) ->
                it 'should return false if bad second param', ->
                    val = globalUtils.areSameArrays([], badArray)
                    val.should.be.false

        it 'should return false if length are differents', ->
            val = globalUtils.areSameArrays([], ['1'])
            val.should.be.false

        it 'should return false if same size but not same data', ->
            val = globalUtils.areSameArrays(['a'], ['b'])
            val.should.be.false

        it 'should return true if same string data', ->
            val = globalUtils.areSameArrays(['a'], ['a'])
            val.should.be.true

        it 'should return true if same number data', ->
            val = globalUtils.areSameArrays([1], [1])
            val.should.be.true

        it 'should return true if they are empty', ->
            val = globalUtils.areSameArrays([], [])
            val.should.be.true
