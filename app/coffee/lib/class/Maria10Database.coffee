'use strict'

###*
# @fileOverview Maria10Database class to manage MariaDB 10.x databases
###

###*
# Required modules
###
apiErrors       = require '../errors.js'
MysqlDatabase   = require './MysqlDatabase.js'
Q               = require 'q'

###*
# Required methods
###
isNotEmptyString = require('../global.js').isNotEmptyString

class Maria10Database extends MysqlDatabase

    ###*
    # Constructor used to create new Maria10Database object
    # @return   {Object}    A new instance of Maria10Database
    ###
    constructor: () ->
        super

    ###*
    # Return the query used to generate the database structure on MariaDB 10.x
    # @return   {String}    Query to execute
    ###
    getDatabaseStructureQuery: () ->
        if not isNotEmptyString(@database)
            return Q.fcall ->
                throw new apiErrors.ParameterError(
                    'database',
                    'string',
                    @database
                )

        dbName          = api.config.database.database
        dbNameLength    = dbName.length + 2

        sql = 'SELECT DISTINCT
                LOWER(ISC.TABLE_SCHEMA)             AS tableSchema,
                LOWER(ISC.TABLE_NAME)               AS tableName,
                LOWER(ISC.COLUMN_NAME)              AS columnName,
                ISC.ORDINAL_POSITION                AS ordinalPosition,
                ISC.COLUMN_DEFAULT                  AS defaultValue,
                LOWER(ISC.IS_NULLABLE)              AS isNullable,
                LOWER(ISC.DATA_TYPE)                AS dataType,
                ISC.CHARACTER_MAXIMUM_LENGTH        AS charMaxLength,
                ISC.CHARACTER_OCTET_LENGTH          AS charOctetLength,
                ISC.NUMERIC_PRECISION               AS numPrecision,
                ISC.NUMERIC_SCALE                   AS numScale,
                ISC.DATETIME_PRECISION              AS datetimePrecision,
                ISC.CHARACTER_SET_NAME              AS charSetName,
                ISC.COLLATION_NAME                  AS collationName,
                LOWER(ISC.COLUMN_TYPE)              AS columnType,
                LOWER(ISC.COLUMN_KEY)               AS columnKey,
                LOWER(ISC.EXTRA)                    AS extra,
                LOWER(ISKCU.REFERENCED_TABLE_NAME)  AS refTableName,
                LOWER(ISKCU.REFERENCED_COLUMN_NAME) AS refColumnName,
                LOWER(IST.TABLE_TYPE)               AS tableType,
                LOWER(ISISI.indexName)              AS uniqueIndexName
            FROM
                INFORMATION_SCHEMA.COLUMNS              AS ISC
                INNER JOIN INFORMATION_SCHEMA.TABLES    AS IST
                    ON (
                                ISC.TABLE_NAME      = IST.TABLE_NAME
                            AND ISC.TABLE_SCHEMA    = IST.TABLE_SCHEMA
                        )
                LEFT OUTER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS ISKCU
                    ON (
                                ISC.TABLE_NAME      = ISKCU.TABLE_NAME
                            AND ISC.COLUMN_NAME     = ISKCU.COLUMN_NAME
                            AND ISC.TABLE_SCHEMA    = ISKCU.TABLE_SCHEMA
                            AND ISKCU.REFERENCED_TABLE_NAME IS NOT NULL
                        )
                LEFT OUTER JOIN
                (
                    SELECT
                        DISTINCT SUBSTRING(
                            INNODB_SYS_TABLES.NAME FROM ' + dbNameLength + '
                        )                            AS tableName,
                        ISI.NAME                     AS indexName,
                        KEY_COLUMN_USAGE.COLUMN_NAME AS columnName
                    FROM
                        INFORMATION_SCHEMA.INNODB_SYS_INDEXES AS ISI
                    INNER JOIN INFORMATION_SCHEMA.INNODB_SYS_TABLES
                        ON ISI.TABLE_ID = INNODB_SYS_TABLES.TABLE_ID
                    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                        ON ISI.NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                    WHERE
                        ISI.TYPE = 2
                        AND INNODB_SYS_TABLES.NAME LIKE \'' + dbName + '%\'
                ) AS ISISI
                    ON (
                                ISC.TABLE_NAME  = ISISI.tableName
                            AND ISC.COLUMN_NAME = ISISI.columnName
                        )
            WHERE
                ISC.TABLE_SCHEMA = \'' + dbName + '\'
                AND ISC.TABLE_NAME NOT LIKE \'api_%\'
                AND ISC.TABLE_NAME NOT LIKE \'my_asp%\'
                AND ISC.TABLE_NAME NOT LIKE \'frontend%\';'

        queryData =
            sql: sql
            values: []

        Q.fcall ->
            queryData

module.exports = Maria10Database
