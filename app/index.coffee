React = require 'react'
domReady = require 'domready'
Router = require 'react-router'
{Routes, Route, DefaultRoute} = Router
# _ = require 'lodash'

# Models
Images = require './models/images'
Me = require './models/student'

# Views
App = require './views/app'
StudentForm = require './views/student_form'
Login = require './views/login'
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
              DefaultRoute
                name: 'login'
                handler: Login
                kai: 'login'
    domReady ->
      React.renderComponent routes, document.body

# run it
module.exports.blastoff()
