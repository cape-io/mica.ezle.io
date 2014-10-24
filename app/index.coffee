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
LoginOk = require './views/login/success'
LoginPending = require './views/login/pending'
LoginFail = require './views/login/fail'

Imgs = require './views/img_form'
ImgUpload = require './views/img_upload'

module.exports =
  blastoff: ->
    self = window.app = @
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
                handler: Login
                name: 'login',
              Route
                name: 'checkEmail'
                path: 'login/ok'
                handler: LoginOk
              Route
                name: 'emailPending'
                path: 'login/pending'
                handler: LoginPending
              Route
                name: 'loginFail'
                path: 'login/fail'
                handler: LoginFail
              Redirect
                path: '/'
                to: 'login'

    domReady ->
      React.renderComponent routes, document.body

# run it
module.exports.blastoff()
