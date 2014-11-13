React = require 'react'
{canvas, div} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    div
      id: 'logo'
    div
      id: 'logobg',
        canvas
          id: 'canvas'
          hidpi: 'on'
          style:
            background: 'transparent'
