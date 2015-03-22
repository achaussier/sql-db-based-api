'use strict'

###*
# @fileOverview This file contains the GenericGetStructureOptions class
# @class GenericGetStructureOptions
###

isArray = require('util').isArray

containsErrorValue          = require('../global.js').containsErrorValue
DatabaseStructure           = require './DatabaseStructure.js'
GenericGetStructureOrder    = require './GenericGetStructureOrder.js'
isNotEmptyString            = require('../global.js').isNotEmptyString
rmErrors    = require '../errors.js'
Q           = require 'q'

class GenericGetStructureOptions

    ###*
    # Constructor of GenericGetStructureOptions class
    # @constructor
    # @return       {Object}    A new GenericGetStructureOrder instance
    ###
    constructor: () ->
        @order  = []
        @limit  = {}

    ###*
    # Set an array to order attribute
    # @param    {String}    ReturnType    List of fields to require
    # @param    {Array}     newOrder      List of fields to require
    # @param    {Object}    dbStructure   Database structure
    # @return   {Boolean}                 True if select succesfully set
    # @throw    {Object}                  ParameterError if bad param
    ###
    setOrder: (returnType, newOrder, dbStructure) ->
        ###*
        # Check if newOrder param is valid
        ###
        if not isNotEmptyString(returnType)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'returnType',
                    'string'
                    returnType
                )
        else if not isArray(newOrder)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'newOrder',
                    'array'
                    newOrder
                )
        else if not (dbStructure instanceof DatabaseStructure)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'dbStructure',
                    'DatabaseStructure'
                    dbStructure
                )
        else
            ###*
            # Check if each path is valid
            ###
            errors = []
            for order in newOrder
                errorObj = null
                if not (order instanceof GenericGetStructureOrder)
                    errorObj = new rmErrors.ParameterError(
                        'order-object',
                        'GenericGetStructureOrder'
                        order
                    )
                else if not dbStructure.checkPath(order.field, returnType)
                    errorObj = new rmErrors.ParameterError(
                        'path',
                        'string'
                        order,
                        'invalid-path-defined-in-order'
                    )
                errors.push errorObj if errorObj?

            if errors.length isnt 0
                Q.fcall ->
                    throw errors
            else
                @order = newOrder
                Q.fcall ->
                    true

    ###*
    # Add a GenericGetStructureOrder object to order attribute
    # @param    {String}    ReturnType    List of fields to require
    # @param    {Object}    order         List of fields to require
    # @param    {Object}    dbStructure   Database structure
    # @return   {Boolean}                 True if order succesfully set
    # @throw    {Object}                  ParameterError if bad param
    ###
    addOrder: (returnType, order, dbStructure) ->
        ###*
        # Check if params are valid
        ###
        if not isNotEmptyString(returnType)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'returnType',
                    'string'
                    returnType
                )
        else if not (order instanceof GenericGetStructureOrder)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'order',
                    'GenericGetStructureOrder'
                    order
                )
        else if not (dbStructure instanceof DatabaseStructure)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'dbStructure',
                    'DatabaseStructure'
                    dbStructure
                )
        else if not dbStructure.checkPath(order.field, returnType)
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'order.field',
                    'string'
                    order.field
                )
        else
            if not @containsOrder(order)
                @order.push order
                Q.fcall ->
                    true
            else
                Q.fcall ->
                    false

    ###*
    # Check if an order is already present in order attribute
    # @param    {Object}    orderToCheck    Order to check in order attribute
    # @return   {boolean}                   True if order exists
    ###
    containsOrder: (orderToCheck) ->
        foundOrder = []
        foundOrder.push(order) for order in @order when (
            orderToCheck?.field is order.field)
        foundOrder.length > 0

    ###*
    # Set limit values for search
    # @param    {Number}    startIndex      Index to use for begin result
    # @param    {Number}    maximumRows     Number of result required
    # @return   {Boolean}                   True if limit values set
    # @throw    {Object}                    ParameterError if bad param
    ###
    setLimit: (startIndex, maximumRows) ->
        ###*
        # Check if params are valid
        ###
        if isNaN(Number(startIndex))
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'startIndex',
                    'number'
                    startIndex
                )
        else if isNaN(Number(maximumRows))
            Q.fcall ->
                throw new rmErrors.ParameterError(
                    'maximumRows',
                    'number'
                    maximumRows
                )
        else
            @startIndex     = startIndex
            @maximumRows    = maximumRows
            Q.fcall ->
                true

module.exports = GenericGetStructureOptions
