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

        it 'should reject if some keys not exists', ->
            obj =
                foo: 'bar'
            arr = [ 'bar' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        it 'should reject if some keys have null value', ->
            obj =
                foo: null
            arr = [ 'foo' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        it 'should resolve if all keys have not null value', ->
            obj =
                foo: 'bar'
            arr = [ 'foo' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        result.should.have.keys 'foo'
                        result.foo.should.be.eql 'bar'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

    describe 'checkKeys', ->

        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        it 'should reject if no param', ->
            globalUtils.checkKeys()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                )

        for badObj in mocksUtils.badObjectParam
            do (badObj) ->

                it 'should reject if bad obj param', ->
                    globalUtils.checkKeys badObj
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
                    globalUtils.checkKeys obj, badArray
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof rmErrors.ParameterError
                        )

        it 'should reject if some keys not exists', ->
            obj =
                foo: 'bar'
            arr = [ 'bar' ]

            globalUtils.checkKeys obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof rmErrors.ParameterError
                        error.message.should.be.eql 'bad-keys-for-object'
                )

        it 'should resolve if some keys have null value', ->
            obj =
                foo: 'bar'
            arr = [ 'foo' ]

            globalUtils.checkKeys obj, arr
                .then(
                    (result) ->
                        result.should.have.keys 'foo'
                        result.foo.should.be.eql 'bar'
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

    describe 'containsErrorValue', ->
        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        it 'should return an array with one error if JS error', ->
            badObj = new Error 'foo'
            val = globalUtils.containsErrorValue { foo: badObj }
            val.should.be.instanceof Array
            val.length.should.be.eql 1

        it 'should return an array with one error if custom error', ->
            badObj = new rmErrors.ParameterError 'foo'
            val = globalUtils.containsErrorValue { foo: badObj }
            val.should.be.instanceof Array
            val.length.should.be.eql 1

        it 'should return an empty array if no error', ->
            val = globalUtils.containsErrorValue { foo: null }
            val.should.be.instanceof Array
            val.length.should.be.eql 0

        it 'should return an empty array if no key', ->
            val = globalUtils.containsErrorValue {}
            val.should.be.instanceof Array
            val.length.should.be.eql 0
