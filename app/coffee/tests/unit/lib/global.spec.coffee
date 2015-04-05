'use strict'

###*
# @fileOverview Unit tests for global lib
###

###*
# Required packages
###
apiErrors   = require '../../../lib/errors.js'
clone       = require 'clone'
globalUtils = require '../../../lib/global.js'
mocks       = require '../_mocks.js'
should      = require 'should'

###*
# Declare variables
###
badObj      = undefined
mocksUtils  = clone mocks
val         = undefined

describe 'Global lib', ->

    describe 'checkKeysHaveNotNullValues', ->

        beforeEach (done) ->
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            done()

        ###*
        # Check without object
        ###
        it 'should reject if no param', ->
            globalUtils.checkKeysHaveNotNullValues()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with a set of bad params
        ###
        for badObj in mocksUtils.badObjectParam
            do (badObj) ->

                it 'should reject if bad obj param', ->
                    globalUtils.checkKeysHaveNotNullValues badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof apiErrors.ParameterError
                        )
        ###*
        # Check with a set of bad params
        ###
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
                                error.should.be.instanceof apiErrors.ParameterError
                        )

        ###*
        # Check with missing keys
        ###
        it 'should reject if some keys not exists', ->
            obj =
                foo: 'bar'
            arr = [ 'bar' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        ###*
        # Check with some null values
        ###
        it 'should reject if some keys have null value', ->
            obj =
                foo: null
            arr = [ 'foo' ]

            globalUtils.checkKeysHaveNotNullValues obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                        error.message.should.be.eql 'missing-mandatory-values-for-object'
                )

        ###*
        # All values are ok
        ###
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
            badObj      = null
            mocksUtils  = clone mocks
            val         = undefined
            done()

        ###*
        # Check without params
        ###
        it 'should reject if no param', ->
            globalUtils.checkKeys()
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                )

        ###*
        # Check with a set of bad values
        ###
        for badObj in mocksUtils.badObjectParam
            do (badObj) ->

                it 'should reject if bad obj param', ->
                    globalUtils.checkKeys badObj
                        .then(
                            (result) ->
                                throw new Error 'Should not be go here in this test'
                            ,(error) ->
                                error.should.be.instanceof apiErrors.ParameterError
                        )

        ###*
        # Check with a set of bad values
        ###
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
                                error.should.be.instanceof apiErrors.ParameterError
                        )

        ###
        # Check with missing keys
        ###
        it 'should reject if some keys not exists', ->
            obj =
                foo: 'bar'
            arr = [ 'bar' ]

            globalUtils.checkKeys obj, arr
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'

                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                        error.message.should.be.eql 'bad-keys-for-object'
                )

        ###*
        # Check with null values
        ###
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

        ###*
        # Check without param
        ###
        it 'should return false if no param', ->
            val = globalUtils.isNotEmptyString()
            val.should.be.false

        ###*
        # Check with a set of bad values
        ###
        for badString in mocksUtils.badNotEmptyStringParam
            do (badString) ->
                it 'should return false if bad string param', ->
                    val = globalUtils.isNotEmptyString badString
                    val.should.be.false

        ###*
        # Check with a non empty string
        ###
        it 'should return true if not empty string param', ->
            val = globalUtils.isNotEmptyString 'foo'
            val.should.be.true

    describe 'areSameArrays', ->
        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        ###*
        # Check without param
        ###
        it 'should return false if no param', ->
            val = globalUtils.areSameArrays()
            val.should.be.false

        ###*
        # Check with a set of bad param
        ###
        for badArray in mocksUtils.badArrayParam
            do (badArray) ->
                it 'should return false if bad first param', ->
                    val = globalUtils.areSameArrays(badArray, [])
                    val.should.be.false

        ###*
        # Check with a set of bad param
        ###
        for badArray in mocksUtils.badArrayParam
            do (badArray) ->
                it 'should return false if bad second param', ->
                    val = globalUtils.areSameArrays([], badArray)
                    val.should.be.false

        ###*
        # Check with arrays with different size
        ###
        it 'should return false if length are differents', ->
            val = globalUtils.areSameArrays([], ['1'])
            val.should.be.false

        ###*
        # Check with diffent data
        ###
        it 'should return false if same size but not same data', ->
            val = globalUtils.areSameArrays(['a'], ['b'])
            val.should.be.false

        ###*
        # Check with same string array
        ###
        it 'should return true if same string data', ->
            val = globalUtils.areSameArrays(['a'], ['a'])
            val.should.be.true

        ###*
        # Check with same number array
        ###
        it 'should return true if same number data', ->
            val = globalUtils.areSameArrays([1], [1])
            val.should.be.true

        ###*
        # Check with empty arrays
        ###
        it 'should return true if they are empty', ->
            val = globalUtils.areSameArrays([], [])
            val.should.be.true

    describe 'containsErrorValue', ->
        beforeEach (done) ->
            badObj = null
            mocksUtils = clone mocks
            val = undefined
            done()

        ###*
        # Test a JS error call
        ###
        it 'should return an array with one error if JS error', ->
            badObj = new Error 'foo'
            val = globalUtils.containsErrorValue { foo: badObj }
            val.should.be.instanceof Array
            val.length.should.be.eql 1

        ###*
        # Check a custom api error return
        ###
        it 'should return an array with one error if custom error', ->
            badObj = new apiErrors.ParameterError 'foo'
            val = globalUtils.containsErrorValue { foo: badObj }
            val.should.be.instanceof Array
            val.length.should.be.eql 1

        ###*
        # Check with empty array
        ###
        it 'should return an empty array if no error', ->
            val = globalUtils.containsErrorValue { foo: null }
            val.should.be.instanceof Array
            val.length.should.be.eql 0

        ###*
        # Check without key
        ###
        it 'should return an empty array if no key', ->
            val = globalUtils.containsErrorValue {}
            val.should.be.instanceof Array
            val.length.should.be.eql 0

    describe 'isStringArray', ->
        beforeEach (done) ->
            val = null
            done()

        ###*
        # Check with bad array content
        ###
        it 'should return false', ->
            val = ['foo', null]
            globalUtils.isStringArray(val).should.be.false

        ###*
        # Check with goodarray content
        ###
        it 'should return true', ->
            val = ['foo', 'bar']
            globalUtils.isStringArray(val).should.be.true

    describe 'capitalizeFirstLetter', ->

        ###*
        # Check with a non empty string
        ###
        it 'should return first capitalized string', ->
            globalUtils.capitalizeFirstLetter 'foo'
                .then(
                    (result) ->
                        result.should.be.eql 'Foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with a non empty string with first capitalized
        ###
        it 'should return first capitalized string', ->
            globalUtils.capitalizeFirstLetter 'Foo'
                .then(
                    (result) ->
                        result.should.be.eql 'Foo'
                    ,(error) ->
                        throw new Error 'Should not be go here in this test'
                )

        ###*
        # Check with a non empty string with first capitalized
        ###
        it 'should return first capitalized string', ->
            globalUtils.capitalizeFirstLetter null
                .then(
                    (result) ->
                        throw new Error 'Should not be go here in this test'
                    ,(error) ->
                        error.should.be.instanceof apiErrors.ParameterError
                )
