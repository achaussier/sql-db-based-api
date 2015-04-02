'use strict'

###*
# @fileOverview This file contains functions used for query building
###

###*
# Required custom classes
###
GenericGetStructureConstraint = require './class/GenericGetStructureConstraint'
GenericGetStructureOptions    = require './class/GenericGetStructureOptions.js'


###*
# Check if param is defined and an instance of GenericGetStructureOptions
# @param    {*}         param       param to test
# @return   {Boolean}               True if it is a GenericGetStructureOptions
###
isGenericGetStructureOptions = (param) ->
    param? and (param instanceof GenericGetStructureOptions)

exports.isGenericGetStructureOptions = isGenericGetStructureOptions

###*
# Check if param is defined and an instance of GenericGetStructureConstraint
# @param    {*}         param       param to test
# @return   {Boolean}               True if it is GenericGetStructureConstraint
###
isGenericGetStructureConstraint = (param) ->
    param? and (param instanceof GenericGetStructureConstraint)

exports.isGenericGetStructureConstraint = isGenericGetStructureConstraint
