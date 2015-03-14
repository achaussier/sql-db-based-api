'use strict'

###*
# @fileOverview Server error class to manage errors about server
###

class ServerError
    constructor: (
        @data,
        @message = 'internal-server-error',
        @code = 500,
        @category = 'server-error'
    ) ->
        Error.captureStackTrace(@,@,@,@)

module.exports = ServerError
