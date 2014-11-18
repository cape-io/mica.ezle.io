React = require 'react'
{div, p} = require 'reactionary'

# List of uploaded images.

module.exports = React.createClass
  #getInitialState: ->

  render: ->
    div
      className: 'uploaded',
        p
          className: 'lead',
            'No images have been uploaded yet.'
