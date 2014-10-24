React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    div null,
      p className: 'lead text-info',
        'One moment please... We are sending you an email.'
