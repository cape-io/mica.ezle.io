React = require 'react'
domReady = require 'domready'
Router = require 'react-router'
{Routes, Route, DefaultRoute, Redirect} = Router
# _ = require 'lodash'

# Data
API = require './data/api.json'

# Models
Images = require './models/images'
Me = require './models/student'

# Views
App = require './views/app'

Login = require './views/login'
LoginForm = require './views/login/login'
LoginOk = require './views/login/success'
LoginPending = require './views/login/pending'
LoginFail = require './views/login/fail'
LoginToken = require './views/login/token'

UsrImgs = require './views/usrImgs'

Mixer = require './views/mixer'
EditProfile = require './views/mixer/profile/profile'
EditImgs = require './views/mixer/images/image'
EditImg = require './views/mixer/images/imageEdit'
EditEmbed = require './views/mixer/embed'
EditEssay = require './views/mixer/essay'

#Imgs = require './views/img_form'

module.exports =
  blastoff: ->
    self = window.app = @
    @api = API
    # Route stuff attach
    @me = new Me()
    # Attach images collection to app global.
    @images = new Images()
    @logOut = =>
      @me.logOut()
      @me = new Me()
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
                name: 'usrImgs'
                handler: UsrImgs
              Route
                name: 'mixer'
                handler: Mixer,
                  Redirect
                    path: '/mixer'
                    to: 'editProfile'
                  Route
                    name: 'editProfile'
                    path: '/mixer/profile/?:uid?'
                    handler: EditProfile
                  Route
                    name: 'editImgs'
                    path: '/mixer/images'
                    handler: EditImgs,
                      Route
                        name: 'editImg'
                        path: '/mixer/images/*'
                        handler: EditImg
                  Route
                    name: 'editEmbed'
                    path: '/mixer/embed'
                    handler: EditEmbed
                  Route
                    name: 'editEssay'
                    path: '/mixer/essay'
                    handler: EditEssay
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
#console.profile()
module.exports.blastoff()
#console.profileEnd()
