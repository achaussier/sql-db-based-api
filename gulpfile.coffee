"use strict"

###*
 * @fileOverview Gulp config file
###
fs          = require 'fs'
gulp        = require 'gulp'
apidoc      = require 'gulp-apidoc'
jsdoc       = require 'gulp-jsdoc'
gutil       = require 'gulp-util'
coffee      = require 'gulp-coffee'
coffeelint  = require 'gulp-coffeelint'
jshint      = require 'gulp-jshint'
changed     = require 'gulp-changed'
nodemon     = require 'gulp-nodemon'
rename      = require 'gulp-rename'
replace     = require 'gulp-replace'
tar         = require "gulp-tar"
gzip        = require 'gulp-gzip'
path        = require 'path'
del         = require 'del'
mocha       = require 'gulp-mocha'
istanbul    = require 'gulp-coffee-istanbul'
protractor  = require("gulp-protractor").protractor
concat      = require 'gulp-concat'
exec        = require('child_process').exec
livereload  = require "gulp-livereload"
plumber     = require "gulp-plumber"
notify      = require "gulp-notify"
gulpif      = require "gulp-if"
runSequence = require "run-sequence"
argv        = require 'yargs'
    .default 'target', 'local'
    .argv
config = require './app/coffee/constants/config'

require('events').EventEmitter.prototype._maxListeners = 100
#
# gzip
#
gulp.task "gzip", [], ->
    d = new Date()
    c_date = d.getDate()
    c_month = d.getMonth() + 1
    c_year = d.getFullYear()
    c_date = '0' + c_date if c_date <= 9
    c_month = '0' + c_month if c_month <= 9
    now = c_year + "-" + c_month + "-" + c_date
    gulp
        .src 'web/**/*'
        .pipe plumber()
        .pipe tar 'rackmonkey-api-' + now + '.' + argv.target + '.tar'
        .pipe gzip()
        .pipe gulp.dest '.'

#
# copy
#
gulp.task "copy", [], ->
    gulp
        .src([
            "./app/js/**"
            "./package.json"
        ])
        .pipe changed './web/js/', { hasChanged: changed.compareSha1Digest }
        .pipe gulp.dest './web/js/'
        .pipe gulpif argv.target in ['local','dev'], livereload()

#
# disable actionhero nodemon
#
gulp.task "disableAhNodemon", [], ->
    gulp
        .src './node_modules/actionhero/bin/methods/start.js'
        .pipe replace(/(.*SIGUSR2.*)restartServer(.*)/, '$1stopProcess$2')
        .pipe gulp.dest './node_modules/actionhero/bin/methods/'

#
# cleanlocaldb
#
gulp.task 'cleanlocaldb', [], ->
    exec './scripts/clean_db_test.sh'

#
# unit tests coverage
#
gulp.task 'unitcov', [], ->

    process.env['PROJECT_ROOT'] = __dirname + config.paths.COMPILED_CODE
    process.env['ACTIONHERO_CONFIG'] = process.env['PROJECT_ROOT'] + config.paths.API_CONFIG
    process.env['NODE_ENV'] = 'local'
    process.env['GULP_TEST'] = true
    process.env['SPECHELPER'] = true

    gulp
        .src [
            "web/js/actions/**/*.js"
            "web/js/initializers/**/*.js"
            "web/js/lib/**/*.js"
            "web/js/config/**/*.js"
        ]
        .pipe plumber()
        .pipe istanbul
            includeUntested: true
        .pipe istanbul.hookRequire()
        .on 'finish', ->
            gulp
                .src [
                    "web/js/tests/unit/**/*.js"
                ]
                .pipe plumber()
                .pipe mocha
                    reporter: 'spec'
                .pipe istanbul.writeReports
                    dir: "web/coverage-unit"
                    reporters: [
                        'lcov'
                        'json'
                        'text'
                        'text-summary'
                    ]
                .on 'error', (err)->
                    gutil.log err
                    gutil.beep()
                    @.emit 'end'

        .on 'error', (err)->
            gutil.log(err)
            gutil.beep()
            @.emit 'end'

#
# end to end tests coverage
#
gulp.task 'e2ecov', [], ->

    process.env['PROJECT_ROOT'] = __dirname + config.paths.COMPILED_CODE
    process.env['ACTIONHERO_CONFIG'] = process.env['PROJECT_ROOT'] + config.paths.API_CONFIG
    process.env['NODE_ENV'] = 'local'
    process.env['GULP_TEST'] = true
    process.env['SPECHELPER'] = true

    gulp
        .src [
            "web/js/actions/**/*.js"
            "web/js/initializers/**/*.js"
            "web/js/lib/**/*.js"
            "web/js/config/**/*.js"
        ]
        .pipe plumber()
        .pipe istanbul
            includeUntested: true
        .pipe istanbul.hookRequire()
        .on 'finish', ->
            gulp
                .src [
                    "web/js/tests/e2e/**/*.js"
                ]
                .pipe plumber()
                .pipe mocha
                    reporter: 'spec'
                .pipe istanbul.writeReports
                    dir: "web/coverage-e2e"
                    reporters: [
                        'lcov'
                        'json'
                        'text'
                        'text-summary'
                    ]
                .on 'error', (err)->
                    gutil.log err
                    gutil.beep()
                    @.emit 'end'

        .on 'error', (err)->
            gutil.log(err)
            gutil.beep()
            @.emit 'end'

#
# unit tests
#
gulp.task 'unittest', [], ->

    process.env['PROJECT_ROOT'] = __dirname + config.paths.COMPILED_CODE
    process.env['ACTIONHERO_CONFIG'] = process.env['PROJECT_ROOT'] + config.paths.API_CONFIG
    process.env['NODE_ENV'] = 'local'
    process.env['SPECHELPER'] = true

    gulp
        .src [
            "web/js/tests/unit/**/*.js"
        ]
        .pipe plumber()
        .pipe mocha
            reporter: 'spec'
        .on 'error', (err)->
            gutil.log err
            gutil.beep()
            @.emit 'end'

#
# end to end tests
#
gulp.task 'e2etest', [], ->

    process.env['PROJECT_ROOT'] = __dirname + config.paths.COMPILED_CODE
    process.env['ACTIONHERO_CONFIG'] = process.env['PROJECT_ROOT'] + config.paths.API_CONFIG
    process.env['NODE_ENV'] = 'local'
    process.env['SPECHELPER'] = true

    gulp
        .src [
            "web/js/tests/e2e/**/*.js"
        ]
        .pipe plumber()
        .pipe mocha
            reporter: 'spec'
        .on 'error', (err)->
            gutil.log err
            gutil.beep()
            @.emit 'end'

#
# coffee lint
#
gulp.task "coffeelint", [], ->
    gulp
        .src([
            'app/coffee/**/*.coffee'
            '!app/coffee/tests/**/*.coffee'
            '!app/coffee/**/_*.coffee'
        ])
        .pipe plumber()
        .pipe(coffeelint(
            opt:
                'indentation' :
                    "value": 4
                    "level": "error"

                'no_trailing_whitespace' :
                    'level' : 'error'

                'max_line_length' :
                    'level' : 'warn'
        ))
        .pipe coffeelint.reporter()

#
# coffee lint
#
gulp.task "coffeelintfortests", [], ->
    gulp
        .src([
            'app/coffee/tests/**/*'
        ])
        .pipe plumber()
        .pipe(coffeelint(
            opt:
                'indentation' :
                    "value": 4
                    "level": "error"

                'no_trailing_whitespace' :
                    'level' : 'error'

                'max_line_length' :
                    'level' : 'ignore'
        ))
        .pipe coffeelint.reporter()

#
# js lint
#
gulp.task "jslint", ->
    gulp
        .src([
            'app/js/**/*.js'
        ])
            .pipe plumber()
            .pipe jshint()
            .pipe jshint.reporter()

#
# clean
#
gulp.task "cleancoffee", [], (cb) ->
    del [
        'web/js/config/servers/**'
        'web/js/config'
        'web/js'
    ], cb

#
# apidoc
#
gulp.task "apidoc", [], ->
    apidoc
        .exec
            src: "app/js"
            dest: "web/doc/user"
            debug: false
            includeFilters: [ ".*\\.js$" ]

#
# jsdoc
#
gulp.task "jsdoc", (done) ->
    gulp
        .src "web/js/**/*.js"
        .pipe jsdoc "web/doc/dev"

#
# coffee
#
gulp.task "coffee", [], ->
    gulp
        .on "error", gutil.log
        .src "./app/coffee/**/*.coffee"
        .pipe plumber()
        .pipe coffee bare: true
        .pipe changed './web/js/', { hasChanged: changed.compareSha1Digest }
        .pipe gulp.dest "./web/js/"
        .pipe gulpif argv.target in ['local','dev'], livereload()

#
# createExportPath
#
gulp.task "createExportPath", ['coffee'], ->
    compiledCodeDir = __dirname + config.paths.COMPILED_CODE
    publicDir = compiledCodeDir + config.paths.API_PUBLIC_FOLDER
    exportDir = compiledCodeDir + config.paths.API_EXPORT_FOLDER

    fs.mkdir publicDir, 0o0775, () ->
        fs.mkdir exportDir, 0o0775, () ->

#
# serve
#
gulp.task "serve", ['coffee', 'copy'], ->
    nodemon(
        env:
            'ACTIONHERO_CONFIG': __dirname + config.paths.COMPILED_CODE + config.paths.API_CONFIG
            'NODE_ENV': 'local'
            'PROJECT_ROOT': __dirname + config.paths.COMPILED_CODE
        script: "node_modules/actionhero/bin/actionhero"
        ignore: ['./web/', './node_modules/']
        options: '--delay 1'
    )
    .on "change", []
    .on "restart", ->

#
# watch coffee
#
gulp.task "watch", ['serve'], ->
    livereload.listen() if argv.target in ['local','dev']
    gulp.watch './app/coffee/**/*.coffee', ['coffee']
    gulp.watch './app/js/**/*.js', ['copy']

#
# default
#
gulp.task 'default', [], ->
    runSequence ['cleancoffee'], ['disableAhNodemon', 'coffeelint', 'coffee', 'copy', 'jsdoc', 'apidoc', 'createExportPath'], 'watch'

gulp.task "build", ['cleancoffee', 'disableAhNodemon', 'coffeelint', 'jslint', 'coffee', 'copy', 'createExportPath'], (done)->
    done() if done
    process.exit()

gulp.task "release", [], ->
    runSequence ['cleancoffee'], ['coffeelint', 'jslint', 'coffee', 'copy', 'apidoc', 'jsdoc', 'createExportPath'], ['gzip']

gulp.task 'unitcoverage', [], ->
    runSequence ['cleancoffee'], ['coffeelintfortests', 'coffeelint', 'coffee', 'cleanlocaldb', 'copy', 'createExportPath'], ['unitcov']

gulp.task 'e2ecoverage', [], ->
    runSequence ['cleancoffee'], ['coffeelintfortests', 'coffeelint', 'coffee', 'cleanlocaldb', 'copy', 'createExportPath'], ['e2ecov']

gulp.task 'unittests', [], ->
    runSequence ['cleancoffee'], ['coffeelintfortests', 'coffeelint', 'coffee', 'cleanlocaldb', 'copy', 'createExportPath'], ['unittest']

gulp.task 'e2etests', [], ->
    runSequence ['cleancoffee'], ['coffeelintfortests', 'coffeelint', 'coffee', 'cleanlocaldb', 'copy', 'createExportPath'], ['e2etest']
