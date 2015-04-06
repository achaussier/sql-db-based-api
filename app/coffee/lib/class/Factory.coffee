'use strict'

###*
# @fileOverview This file contain the definition of Factory class
# @class        Factory
###

###*
# Required modules
###
apiErrors   = require '../errors.js'
Q           = require 'q'

###*
# Required methods
###
capitalizeFirstLetter   = require('../global.js').capitalizeFirstLetter
isArray                 = require('util').isArray
isNotEmptyString        = require('../global.js').isNotEmptyString

class Factory

    ###*
    # Constructor for Factory objects
    # @constructor
    # @param        {String}    objType     Type of object
    # @param        {Boolean}   isGeneric   True if it is for database objects
    # @return       {Object}                New factory instance
    # @throw        {Object}                ParameterError or ServerError
    ###
    constructor: (objType, isGeneric, factoryName) ->

        ###*
        # Check params received
        ###
        checkParams = @checkConstructorParams(
            objType,
            isGeneric,
            factoryName
        )
        if checkParams.length isnt 0
            return checkParams

        ###*
        # Params are OK, so set basic informations for factory
        ###
        @isGeneric  = isGeneric
        @objType    = capitalizeFirstLetter(objType)
        @name       = capitalizeFirstLetter(factoryName)

    ###*
    # Check constructor parameters
    # @param        {String}    objType     Type of object
    # @param        {Boolean}   isGeneric   True if it is for database objects
    # @return       {Array}                 Empty array if no errors
    # @throw        {Object}                ParameterError objects
    ###
    checkConstructorParams: (objType, isGeneric, factoryName) ->
        errors = []

        if not isNotEmptyString objType
            errors.push new apiErrors.ParameterError(
                'objType',
                'not-empty-string'
                objType
            )
        if isGeneric isnt true and isGeneric isnt false
            errors.push new apiErrors.ParameterError(
                'isGeneric',
                'boolean'
                isGeneric
            )
        if not isNotEmptyString factoryName
            errors.push new apiErrors.ParameterError(
                'factoryName',
                'not-empty-string'
                factoryName
            )
        errors

    ###*
    # Method used when GET request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    structure   Request structure build by controller
    # @throw    {Object}                ServerError, this class should be extend
    ###
    get: (api, structure) ->
        errorObj = new apiErrors.ServerError(
            @name,
            'get-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    ###*
    # Method used when POST request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    structure   Request structure build by controller
    # @throw    {Object}                ServerError, this class should be extend
    ###
    post: (api, structure)->
        errorObj = new apiErrors.ServerError(
            @name,
            'post-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    ###*
    # Method used when PUT request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    structure   Request structure build by controller
    # @throw    {Object}                ServerError, this class should be extend
    ###
    put: (api, structure) ->
        errorObj = new apiErrors.ServerError(
            @name,
            'put-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    ###*
    # Method used when PATCH request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    structure   Request structure build by controller
    # @throw    {Object}                ServerError, this class should be extend
    ###
    patch: (api, structure)->
        errorObj = new apiErrors.ServerError(
            @name,
            'patch-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    ###*
    # Method used when DELETE request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    structure   Request structure build by controller
    # @throw    {Object}                ServerError, this class should be extend
    ###
    del: (api, structure)->
        errorObj = new apiErrors.ServerError(
            @name,
            'del-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    @getFactory: (factories, factoryName) ->

        errors = []

        ###*
        # Check factories param
        ###
        if not factories? or not isArray(factories)
            errorObj = new apiErrors.ParameterError(
                'factories',
                'Array',
                factories
            )
            errors.push errorObj

        ###*
        # Check factoryName param
        ###
        if not isNotEmptyString factoryName
            errorObj = new apiErrors.ParameterError(
                'factoryName',
                'not-empty-string',
                factoryName
            )
            errors.push errorObj

        ###*
        # If param error reject, else
        ###
        if errors.length > 0
            return Q.fcall ->
                throw errors

        factory = (obj for obj in factories when obj.name is factoryName)

        if factory.length > 1
            return Q.fcall ->
                throw new apiErrors.ServerError(
                    factory,
                    'should-not-exist-factories-with-same-name'
                )

        Q.fcall ->
            factory[0]

module.exports = Factory
