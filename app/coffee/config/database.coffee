'use strict'

###*
 * @fileoverview Database config
###

###*
 * Default configuration
 * @type {Object}
###
exports.default =
  database: (api) ->
      host:               process.env['API_CONF_DB_HOST'] or null
      user:               process.env['API_CONF_DB_USER'] or null
      password:           process.env['API_CONF_DB_PASSWORD'] or null
      port:               process.env['API_CONF_DB_PORT'] or 3306
      database:           process.env['API_CONF_DB_NAME'] or null
      multipleStatements: true
      metadata:           true
      dialect:            'mysql'
