path = require 'path'
fs = require 'fs'

gulp = require 'gulp'
r = require 'request'
yaml = require 'js-yaml'

browserSync = require 'browser-sync'

browserify = require 'browserify'
watchify = require 'watchify'
coffeeify = require 'coffeeify'
bd = require 'browserify-data'
source = require('vinyl-source-stream')

jade = require 'gulp-jade'
less = require 'gulp-less'
clean = require 'gulp-clean'
zopfli = require 'gulp-zopfli'
rename = require 'gulp-rename'
runSequence = require 'run-sequence'

API = 'http://mica.ezle.io.ld:8000/'
#API = 'https://mica.ezle.io/'

data = yaml.safeLoad fs.readFileSync('data.yaml', 'utf8')

gulp.task "default", ['browser-sync'], ->
  gulp.watch "templates/*.jade", ["templates"]
  gulp.watch "styles/*.less", ["styles"]
  gulp.watch 'images/**', ['copy']
  return

gulp.task "browser-sync", ['compile', 'styles', 'templates', 'copy'], ->
  browserSync.init "dev/**",
    server:
      baseDir: "dev" # Change this to your web root dir
    injectChanges: false
    logConnections: true
    ghostMode:
      clicks: true
      scroll: true
      location: true
  return

gulp.task "templates", ->
  gulp.src("templates/*.jade")
    .pipe jade(locals: data)
    .pipe gulp.dest("./dev/")
  return

gulp.task 'copy', ->
  gulp.src('./images/**')
    .pipe gulp.dest('./dev/images/')

gulp.task 'styles', ->
  gulp.src(["styles/app.less", 'styles/print.less', 'styles/iefix.less'])
    .pipe less(paths: [path.join(__dirname, "less", "includes")])
    .pipe gulp.dest("./dev")

gulp.task 'compile', ->
  opts = watchify.args
  opts.extensions = ['.coffee', '.json']
  w = watchify(browserify('./app/index.coffee', opts))
  w.transform coffeeify
  w.transform bd
  bundle = () ->
    w.bundle()
      .pipe(source('app.js'))
      .pipe(gulp.dest('./dev/'))
  w.on('update', bundle)
  bundle()
  return

gulp.task 'updateUsers', (cb) ->
  r API+'9df66d7d/updateUsers.json', (err, resp, body) ->
    throw err if err
    console.log body
    cb()

gulp.task 'uids', ->
  r(API+'uids.json')
    .pipe source('uids.json')
    .pipe gulp.dest('./app/data/')

gulp.task 'studentSchema', ->
  r(API+'studentSchema.json')
    .pipe source('studentSchema.json')
    .pipe gulp.dest('./app/data/')

gulp.task 'data', ['uids', 'studentSchema'], ->
  r(API+'users.json')
    .pipe source('users.json')
    .pipe gulp.dest('./app/data/')

# - - - - prod - - - -

gulp.task 'set_sha', (cb) ->
  r_ops =
    uri: 'https://api.github.com/repos/ookb/rg-client-app/branches/master'
    json: true
    headers:
      'user-agent': 'request.js'
  r r_ops, (err, response, body) ->
    if err then throw err
    global.sha = body.commit.sha
    cb()
  return

# Remove contents from prod directory.
gulp.task 'prod_clean', ->
  gulp.src('./prod', read: false)
    .pipe(clean())

gulp.task 'prod_compile', (cb) ->
  # Javascript bundle
  opts =
    debug: true
    extensions: ['.coffee', '.json']
  bundler = browserify opts
  bundler.transform coffeeify
  bundler.transform bd
  bundler.add('./app/index.coffee')
  bundler.plugin 'minifyify',
    map: 'script.map.json'
    output: './prod/script.map.json'
  bundler.bundle debug: true
    .pipe(source(global.sha+'.js'))
    .pipe(gulp.dest('./prod/'))
    .on('end', cb)
  return

gulp.task 'prod_template', ->
  # Templates
  data.sha = global.sha

  gulp.src("templates/*.jade")
    .pipe jade(locals: data)
    .pipe gulp.dest("./prod/")

gulp.task 'copy_css', ['styles'], ->
  gulp.src('./dev/app.css')
    .pipe(rename(global.sha+'.css'))
    .pipe(gulp.dest('./prod'))
  gulp.src('./dev/print.css', './dev/iefix.css')
    .pipe(gulp.dest('./prod'))
  gulp.src('./images/**')
    .pipe gulp.dest('./prod/images/')

gulp.task 'compress', ->
  gulp.src("./prod/**")
    .pipe(zopfli())
    .pipe(gulp.dest("./prod"))

gulp.task 'prod', (cb) ->
  runSequence ['prod_clean', 'set_sha'],
    ['prod_template', 'copy_css', 'prod_compile'],
    'compress',
    cb
  return
