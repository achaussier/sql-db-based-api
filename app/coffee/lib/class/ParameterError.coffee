'use strict'

###*
# @fileOverview Parameter error class to manage errors about parameters
###

class ParameterError
    constructor: (
        @name,
        @expected,
        @received,
        @message    = 'bad-parameter-received',
        @code       = 400,
        @category   = 'parameter-error'
    ) ->
        Error.captureStackTrace(@,@,@,@,@,@)

module.exports = ParameterError
