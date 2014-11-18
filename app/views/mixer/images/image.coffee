React = require 'react/addons'
cx = React.addons.classSet
{div, h2} = require 'reactionary'

ImageUpload = require './imageUpload'
ImageUploads = require './images'

# Images index view.

module.exports = React.createClass

  render: ->
    div
      className: 'images',
        @props.activeRouteHandler(null)
        ImageUpload @props
        h2 'Uploaded Images'
        ImageUploads @props
