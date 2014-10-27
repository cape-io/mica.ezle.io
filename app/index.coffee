React = require 'react'
domReady = require 'domready'
Router = require 'react-router'
{Routes, Route, DefaultRoute, Redirect} = Router
# _ = require 'lodash'

# Models
Images = require './models/images'
Me = require './models/student'

# Views
App = require './views/app'
StudentForm = require './views/student_form'

Login = require './views/login'
LoginForm = require './views/login/login'
LoginOk = require './views/login/success'
LoginPending = require './views/login/pending'
LoginFail = require './views/login/fail'
LoginToken = require './views/login/token'

Mixer = require './views/mixer'

Imgs = require './views/img_form'
ImgUpload = require './views/img_upload'

module.exports =
  blastoff: ->
    self = window.app = @
    # Route stuff attach
    @me = new Me()
    # Attach images collection to app global.
    @images = new Images()
    # Init the React application router.
    routes =
      Routes
        location: 'hash',
          Route
            name: 'app'
            path: '/'
            kai: true
            handler: App,
              Route
                name: 'img'
                handler: ImgUpload
                kai: 'img'
              Route
                name: 'mixer'
                handler: Mixer,

              Route
                handler: Login
                name: 'login',
                  DefaultRoute handler: LoginForm
                  Route
                    name: 'checkEmail'
                    path: '/login/ok'
                    handler: LoginOk
                  Route
                    name: 'emailPending'
                    path: '/login/pending'
                    handler: LoginPending
                  Route
                    name: 'loginFail'
                    path: '/login/fail'
                    handler: LoginFail
                  Route
                    name: 'loginToken'
                    path: '/login/:uid/:tempToken'
                    handler: LoginToken
              Redirect
                path: '/'
                to: 'login'

    domReady =>
      @.container = React.renderComponent routes, document.body

# run it
module.exports.blastoff()
