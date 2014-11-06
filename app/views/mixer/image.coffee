React = require 'react/addons'
cx = React.addons.classSet
{div, h2} = require 'reactionary'

ImageUpload = require './imageUpload'
ImageUploads = require './images'

module.exports = React.createClass

  render: ->
    div
      className: 'images',
        ImageUpload @props
        h2 'Uploaded Images'
        ImageUploads @props
