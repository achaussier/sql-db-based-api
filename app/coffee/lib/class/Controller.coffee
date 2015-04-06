'use strict'

###*
# @fileOverview This file contain the defination of Controller class
# @class        Controller
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
isNotEmptyString        = require('../global.js').isNotEmptyString

class Controller

    ###*
    # Constructor for Controller objects
    # @constructor
    # @param        {String}    objType         Type of object
    # @param        {Boolean}   isGeneric       True for database objects
    # @param        {String}    controllerName  Controller name
    # @return       {Object}                    New controller instance
    # @throw        {Object}                    ParameterError or ServerError
    ###
    constructor: (objType, isGeneric, controllerName) ->

        ###*
        # Check params received
        ###
        checkParams = @checkConstructorParams(
            objType,
            isGeneric,
            controllerName
        )
        if checkParams.length isnt 0
            return checkParams

        ###*
        # Params are OK, so set basic informations for controller
        ###
        @isGeneric  = isGeneric
        @objType    = capitalizeFirstLetter(objType)
        @name       = capitalizeFirstLetter(controllerName)

    ###*
    # Check constructor parameters
    # @param        {String}    objType         Type of object
    # @param        {Boolean}   isGeneric       True for database objects
    # @param        {String}    controllerName  Controller name
    # @return       {Array}                     Empty array if no errors
    # @throw        {Object}                    ParameterError objects
    ###
    checkConstructorParams: (objType, isGeneric, controllerName) ->
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
        if not isNotEmptyString controllerName
            errors.push new apiErrors.ParameterError(
                'controllerName',
                'not-empty-string'
                controllerName
            )
        errors

    ###*
    # Method used when GET request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    params      Params set by user
    # @throw    {Object}                ServerError, this class should be extend
    ###
    get: (api, params) ->
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
    # @param    {Object}    params      Params set by user
    # @throw    {Object}                ServerError, this class should be extend
    ###
    post: (api, params)->
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
    # @param    {Object}    params      Params set by user
    # @throw    {Object}                ServerError, this class should be extend
    ###
    put: (api, params) ->
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
    # @param    {Object}    params      Params set by user
    # @throw    {Object}                ServerError, this class should be extend
    ###
    patch: (api, params)->
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
    # @param    {Object}    params      Params set by user
    # @throw    {Object}                ServerError, this class should be extend
    ###
    del: (api, params)->
        errorObj = new apiErrors.ServerError(
            @name,
            'del-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

module.exports = Controller
