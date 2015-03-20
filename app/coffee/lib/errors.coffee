'use strict'

###*
# @fileOverview Export all custom error classes
###

DatabaseError   = require './class/DatabaseError.js'
ParameterError  = require './class/ParameterError.js'
ServerError     = require './class/ServerError.js'

exports.DatabaseError   = DatabaseError
exports.ParameterError  = ParameterError
exports.ServerError     = ServerError

###*
# Check if param is an instance of javascript error
# @param    {*}         param   Param to check
# @return   {Boolean}           True if param is instance of javascript Error
###
isJsError = (param) ->
    param instanceof Error

exports.isJsError = isJsError

###*
# Check if param is an instance of a custom app error
# @param    {*}         param   Param to check
# @return   {Boolean}           True if param is instance of custom app Error
###
isCustomError = (param) ->

    switch
        when param instanceof ParameterError   then true
        when param instanceof ServerError      then true
        when param instanceof DatabaseError    then true
        else false

exports.isCustomError = isCustomError
