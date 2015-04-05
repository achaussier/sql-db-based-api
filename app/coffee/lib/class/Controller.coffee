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
    # @controller
    # @param        {String}    objType     Type of object
    # @param        {Boolean}   isGeneric   True if it is for database objects
    # @return       {Object}                New controller instance
    # @throw        {Object}                ParameterError or ServerError
    ###
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

    ###*
    # Check constructor parameters
    # @param        {String}    objType     Type of object
    # @param        {Boolean}   isGeneric   True if it is for database objects
    # @return       {Array}                 Empty array if no errors
    # @throw        {Object}                ParameterError objects
    ###
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

    ###*
    # Method used when GET request, but should be extend before use
    # @param    {Object}    api         Main app object
    # @param    {Object}    connection  Request object
    # @throw    {Object}                ServerError, this class should be extend
    ###
    get: (api, connection) ->
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
    # @param    {Object}    connection  Request object
    # @throw    {Object}                ServerError, this class should be extend
    ###
    post: (api, connection)->
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
    # @param    {Object}    connection  Request object
    # @throw    {Object}                ServerError, this class should be extend
    ###
    put: (api, connection)->
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
    # @param    {Object}    connection  Request object
    # @throw    {Object}                ServerError, this class should be extend
    ###
    patch: (api, connection)->
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
    # @param    {Object}    connection  Request object
    # @throw    {Object}                ServerError, this class should be extend
    ###
    del: (api, connection)->
        errorObj = new apiErrors.ServerError(
            @name,
            'del-method-not-implemented',
            501
        )
        Q.fcall ->
            throw errorObj

module.exports = Controller
