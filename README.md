
# SQL DATABASE BASED API
========================

## Status
---------

- ![Build status](https://travis-ci.org/achaussier/sql-db-based-api.svg?branch=master)
- ![Coverage status](https://coveralls.io/repos/achaussier/sql-db-based-api/badge.svg?branch=master)](https://coveralls.io/r/achaussier/sql-db-based-api?branch=master)


## Installation
---------------

You need to have a valid nodejs installation to use this api.

Before use the api, you need to install prerequisites.

> - npm install


## Usage
--------

This api send asset informations of infrastructure.

#### To display help
> - node app.js -h
> - node app.js --help

#### To start app
> - node app.js

#### To specify a config file
Note that method take preference over existing settings
> - node app.js -c '/etc/appConfig.json'
> - node app.js --config '/etc/appConfig.json'


## Tests
--------

This api is tests covered. To use end to end tests and coverage, you need to
use a valid configuration.

#### To launch unit tests :
> - gulp unittests

#### To see the unit tests coverage :
> - gulp unitcoverage

#### To launch end to end tests :
> - gulp e2etests

#### To see the end to end tests coverage :
> - gulp e2ecoverage
