'use strict'

###*
# @fileOverview Unit tests for orm lib
###

# require packages
clone               = require 'clone'
DatabaseStructure   = require '../../../lib/class/DatabaseStructure.js'
Field               = require '../../../lib/class/Field.js'
mocks               = require '../_mocks.js'
ormUtils            = require '../../../lib/orm.js'
Relation            = require '../../../lib/class/Relation.js'
rmErrors            = require '../../../lib/errors.js'
sinon               = require 'sinon'
should              = require 'should'
Table               = require '../../../lib/class/Table.js'

# declare variables
badObj      = undefined
dbStructure = undefined
field       = undefined
mocksUtils  = clone mocks
relation    = undefined
stub        = undefined
stub2       = undefined
table       = undefined
val         = undefined

describe 'ORM lib', ->






