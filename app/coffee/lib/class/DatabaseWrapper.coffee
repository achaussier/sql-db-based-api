'use strict'

###*
# @fileOverview DatabaseWrapper class to wrap database classes
###

###*
# Required modules
###
Q               = require 'q'
rmErrors        = require '../errors.js'

class DatabaseWrapper

    ###*
    # Constructor used to create new DatabaseWrapper object
    # @return   {Object}    A new instance of DatabaseWrapper
    ###
    constructor: () ->

    ###*
    # Return a promise connection from a read only pool
    # @return   {Function}  A connection from a read only pool
    # @throw    {Object}    A ParameterError Object if no read only pool
    ###
    getReadConnection: () ->
        Q.fcall ->
            throw new rmErrors.ServerError(
                'buildInnerJoin should be extended by a sub class'
            )
    ###*
    # Return a promise connection from a read only pool
    # @return   {Function}  A connection from a read only pool
    # @throw    {Object}    A ParameterError Object if no read only pool
    ###
    getWriteConnection: () ->
        Q.fcall ->
            throw new rmErrors.ServerError(
                'buildInnerJoin should be extended by a sub class'
            )
    ###*
    # Execute select sql query
    # @param    {Object}    connection  Database connection
    # @param    {Object}    queryData   Query data (sql, option, values)
    # @return   {Object}                Database result fo this query and fields
    # @throw    {Object}                DatabaseError if error during query
    # @throw    {Object}                ParameterError if invalid params
    ###
    executeSelect: (connection, queryData) ->
        Q.fcall ->
            throw new rmErrors.ServerError(
                'buildInnerJoin should be extended by a sub class'
            )

module.exports = DatabaseWrapper
