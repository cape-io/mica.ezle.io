React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    div null,
      p className: 'lead',
        'Great! Please check your MICA email for a link to access the upload area.'
      p 'The email is from ezle.io'
