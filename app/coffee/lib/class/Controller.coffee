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

    constructor: (objType, isGeneric) ->

        ###*
        # Check params received
        ###
        checkParams = @checkConstructorParams(
            objType,
            isGeneric
        )
        if checkParams.length isnt 0
            return checkParams

        ###*
        # Params are OK, so set basic informations for controller
        ###
        @isGeneric  = isGeneric
        @objType = capitalizeFirstLetter(objType)

        if isGeneric
            @name = 'Generic' + @objType
        else
            @name = @objType

    checkConstructorParams: (objType, isGeneric) ->
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
        errors

    get: (api, connection) ->
        errorObj = new apiErrors.ServerError(
            @name,
            'get-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    post: (api, connection)->
        errorObj = new apiErrors.ServerError(
            @name,
            'post-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    put: (api, connection)->
        errorObj = new apiErrors.ServerError(
            @name,
            'put-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    patch: (api, connection)->
        errorObj = new apiErrors.ServerError(
            @name,
            'patch-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

    del: (api, connection)->
        errorObj = new apiErrors.ServerError(
            @name,
            'del-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

module.exports = Controller
