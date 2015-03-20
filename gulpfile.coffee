'use strict'

###*
 * @fileOverview Gulp config file
###

###*
# Require modules to use with gulp
###
argv        = require 'yargs'
    .default 'target', 'local'
    .argv
apidoc      = require 'gulp-apidoc'
changed     = require 'gulp-changed'
coffee      = require 'gulp-coffee'
coffeelint  = require 'gulp-coffeelint'
concat      = require 'gulp-concat'
del         = require 'del'
exec        = require('child_process').exec
fs          = require 'fs'
gulp        = require 'gulp'
gulpif      = require 'gulp-if'
gutil       = require 'gulp-util'
gzip        = require 'gulp-gzip'
istanbul    = require 'gulp-coffee-istanbul'
jsdoc       = require 'gulp-jsdoc'
jshint      = require 'gulp-jshint'
livereload  = require 'gulp-livereload'
mocha       = require 'gulp-mocha'
nodemon     = require 'gulp-nodemon'
notify      = require 'gulp-notify'
path        = require 'path'
plumber     = require 'gulp-plumber'
protractor  = require('gulp-protractor').protractor
rename      = require 'gulp-rename'
replace     = require 'gulp-replace'
runSequence = require 'run-sequence'
tar         = require 'gulp-tar'

###*
# Require app constants
###
config = require './app/coffee/constants/config'

###*
# Set event listeners
###
require('events').EventEmitter.prototype._maxListeners = 100

###*
# Set some env variables
# @todo Check if it's a good idea
###
process.env.PROJECT_ROOT        = __dirname + config.paths.COMPILED_CODE
process.env.ACTIONHERO_CONFIG   = process.env.PROJECT_ROOT + config.paths.API_CONFIG
process.env.NODE_ENV            = 'local'
process.env.GULP_TEST           = true
process.env.SPECHELPER          = true

###*
# Paths for coverage inspection
###
coveragePaths = [
    'dist/actions/**/*.js'
    'dist/initializers/**/*.js'
    'dist/lib/**/*.js'
    'dist/config/**/*.js'
    'dist/app.js'

]

###*
# GZIP task : used to zip files after build
###
gulp.task 'gzip', [], ->
    d       = new Date()
    c_date  = d.getDate()
    c_month = d.getMonth() + 1
    c_year  = d.getFullYear()
    c_date  = '0' + c_date if c_date <= 9
    c_month = '0' + c_month if c_month <= 9
    now     = c_year + "-" + c_month + "-" + c_date
    gulp
        .src 'dist/**/*'
        .pipe plumber()
        .pipe tar 'asset-api-' + now + '.' + argv.target + '.tar'
        .pipe gzip()
        .pipe gulp.dest '.'


###*
# Copy package.json file to launch npm instal command on install
###
gulp.task 'copyPackageJson', [], ->
    gulp
        .src './package.json'
        .pipe changed './dist/', { hasChanged: changed.compareSha1Digest }
        .pipe gulp.dest './dist/'
        .pipe gulpif argv.target in ['local','dev'], livereload()

###*
# Copy changelog.txt to public folder
###
gulp.task 'copyChangelog', [], ->
    gulp
        .src './package.json'
        .pipe gulp.dest './dist/public/'


###*
# Rename README.md to help.txt to display help after release
###
gulp.task 'renameReadme', [], ->
    gulp
        .src [
            './README.md'
        ]
        .pipe rename('help.txt')
        .pipe gulp.dest './dist'

###*
# Disable actionhero nodemon, conflict with livereload
###
gulp.task 'disableAhNodemon', [], ->
    gulp
        .src './node_modules/actionhero/bin/methods/start.js'
        .pipe replace(/(.*SIGUSR2.*)restartServer(.*)/, '$1stopProcess$2')
        .pipe gulp.dest './node_modules/actionhero/bin/methods/'


###*
# Unit tests coverage
###
gulp.task 'unitcov', [], ->
    gulp
        .src coveragePaths
        .pipe plumber()
        .pipe istanbul
            includeUntested: true
        .pipe istanbul.hookRequire()
        .on 'finish', ->
            gulp
                .src 'dist/tests/unit/**/*.js'
                .pipe plumber()
                .pipe mocha
                    reporter: 'spec'
                .pipe istanbul.writeReports
                    dir: 'dist/public/coverage/unit'
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


###*
# End to end tests coverage
###
gulp.task 'e2ecov', [], ->
    gulp
        .src coveragePaths
        .pipe plumber()
        .pipe istanbul
            includeUntested: true
        .pipe istanbul.hookRequire()
        .on 'finish', ->
            gulp
                .src 'dist/tests/e2e/**/*.js'
                .pipe plumber()
                .pipe mocha
                    reporter: 'spec'
                .pipe istanbul.writeReports
                    dir: 'dist/public/coverage/e2e'
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


###*
# Unit tests
###
gulp.task 'unittest', [], ->
    gulp
        .src 'dist/tests/unit/**/*.js'
        .pipe plumber()
        .pipe mocha
            reporter: 'spec'
        .on 'error', (err)->
            gutil.log err
            gutil.beep()
            @.emit 'end'


###*
# End to end tests
###
gulp.task 'e2etest', [], ->
    gulp
        .src 'dist/tests/e2e/**/*.js'
        .pipe plumber()
        .pipe mocha
            reporter: 'spec'
        .on 'error', (err)->
            gutil.log err
            gutil.beep()
            @.emit 'end'


###*
# Coffee lint for code
###
gulp.task 'coffeelint', [], ->
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
                    'value': 4
                    'level': 'error'

                'no_trailing_whitespace' :
                    'level' : 'error'

                'max_line_length' :
                    'level' : 'warn'
        ))
        .pipe coffeelint.reporter()


###*
# Coffee lint for tests
###
gulp.task 'coffeelintfortests', [], ->
    gulp
        .src 'app/coffee/tests/**/*'
        .pipe plumber()
        .pipe(coffeelint(
            opt:
                'indentation' :
                    'value': 4
                    'level': 'error'

                'no_trailing_whitespace' :
                    'level' : 'error'

                'max_line_length' :
                    'level' : 'ignore'
        ))
        .pipe coffeelint.reporter()


###*
# Clean compiled dir
###
gulp.task 'clean', [], (cb) ->
    del [ './dist/**/*' ], cb


###*
# Apidoc to generate documentation for api actions
###
gulp.task 'apidoc', [], ->
    apidoc
        .exec
            src             : 'dist/actions'
            dest            : 'dist/public/doc/user'
            debug           : false
            includeFilters  : [ '*.js' ]


###*
# JSdoc to generate development documentation
###
gulp.task 'jsdoc', (done) ->
    gulp
        .src [
            'dist/actions/**/*.js'
            'dist/config/**/*.js'
            'dist/initializers/**/*.js'
            'dist/lib/**/*.js'
            'dist/app.js'
        ]
        .pipe jsdoc 'dist/public/doc/dev'


###*
# Coffeescript compilation
###
gulp.task 'coffee', [], ->
    gulp
        .on 'error', gutil.log
        .src './app/coffee/**/*.coffee'
        .pipe plumber()
        .pipe coffee bare: true
        .pipe changed './dist/', { hasChanged: changed.compareSha1Digest }
        .pipe gulp.dest './dist/'
        .pipe gulpif argv.target in ['local','dev'], livereload()


###*
# Create paths for exports
###
gulp.task "createExportPath", ['coffee'], ->
    compiledCodeDir = __dirname + config.paths.COMPILED_CODE
    publicDir       = compiledCodeDir + config.paths.API_PUBLIC_FOLDER
    exportDir       = compiledCodeDir + config.paths.API_EXPORT_FOLDER

    fs.mkdir publicDir, 0o0775, () ->
        fs.mkdir exportDir, 0o0775, () ->


###*
# Serve a local instance of api
###
gulp.task 'serve', ['coffee', 'copy'], ->
    nodemon(
        env:
            'ACTIONHERO_CONFIG' : __dirname + config.paths.COMPILED_CODE + config.paths.API_CONFIG
            'NODE_ENV'          : 'local'
            'PROJECT_ROOT'      : __dirname + config.paths.COMPILED_CODE
        script: 'node_modules/actionhero/bin/actionhero'
        ignore: ['./dist/', './node_modules/']
        options: '--delay 1'
    )
    .on 'change', []
    .on 'restart', ->


###*
# Watch coffee
###
gulp.task 'watch', ['serve'], ->
    livereload.listen() if argv.target in ['local','dev']
    gulp.watch './app/coffee/**/*.coffee', ['coffee']


###*
# Default task if no task specified
###
gulp.task 'default', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'disableAhNodemon'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'jsdoc'
            'apidoc'
            'createExportPath'
        ],
        'watch'
    )


###*
# Build task
###
gulp.task 'build', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'createExportPath'
        ]
    )


###*
# Release task. Generate a tgz file to deploy.
###
gulp.task 'release', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'apidoc'
            'jsdoc'
            'createExportPath'
        ],
        ['gzip']
    )


###*
# Unit test coverage
###
gulp.task 'unitcoverage', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelintfortests'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'createExportPath'
        ],
        ['unitcov']
    )


###*
# End to end code coverage
###
gulp.task 'e2ecoverage', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelintfortests'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'createExportPath'
        ],
        ['e2ecov']
    )


###*
# Unit tests task
###
gulp.task 'unittests', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelintfortests'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'createExportPath'
        ],
        ['unittest']
    )


###*
# End to end tests
###
gulp.task 'e2etests', [], ->
    runSequence(
        ['clean'],
        [
            'renameReadme'
            'coffeelintfortests'
            'coffeelint'
            'coffee'
            'copyPackageJson'
            'copyChangelog'
            'createExportPath'
        ],
        ['e2etest']
    )
