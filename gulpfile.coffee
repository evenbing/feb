gulp = require 'gulp'
del = require 'del'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
browserify = require 'gulp-browserify'
livereload = require 'gulp-livereload'
extReplace = require 'gulp-ext-replace'

paths = 
  src: ['src/**/*']
  scripts: ['src/scripts/*.coffee']
  stylesheets: ['src/stylesheets/*.less']

logError = (e)->
  console.log e
  this.emit 'end'

# Remove previously compiled files
gulp.task 'clean', (cb)->
  del.sync('bin')

# Compile coffeeScript to JavaScript and leverage Browserify
gulp.task 'coffee', -> 
  gulp.src(paths.scripts, {read: no})
      .pipe browserify
        debug: true,
        transform: ['coffeeify'],
        extensions: ['.coffee']
      .on 'error', logError
      .pipe extReplace '.js'
      .pipe gulp.dest 'bin/scripts/'
      .pipe livereload()

gulp.task 'less', ->
  gulp.src paths.stylesheets
      .pipe less()
      .on 'error', logError
      .pipe gulp.dest 'bin/stylesheets/'
      .pipe livereload()

gulp.task 'watch', ->      
  livereload.listen()
  gulp.watch 'src/scripts/**/*', ['coffee']
  gulp.watch 'src/stylesheets/**/*', ['less']

gulp.task 'default', ['clean', 'coffee', 'less', 'watch']