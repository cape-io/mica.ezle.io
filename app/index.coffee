React = require 'react'
SubCollection = require 'ampersand-subcollection'
_ = require 'lodash'

Images = require './models/images'

Router = require './react-router'

module.exports =
  blastoff: ->
    window._ = _
    self = window.app = @
    @images = new Images()
    # Init the React application router.
    el = document.getElementById('react')
    routerComponent = Router {}
    @container = React.renderComponent routerComponent, el

# run it
module.exports.blastoff()
