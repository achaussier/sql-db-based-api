'use strict'

###*
# @fileOverview Database error class to manage errors about database and queries
###

class DatabaseError
    constructor: (
        @data,
        @message = 'query-error',
        @code = 400,
        @category = 'database-error'
    ) ->
        Error.captureStackTrace(@,@,@,@)

module.exports = DatabaseError
