React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'
{Link} = require 'react-router'
module.exports = React.createClass
  # getInitialState: ->

  render: ->
    div null,
      p className: 'lead',
        'We are terribly sorry! Some crazy solar flare must have disrupted the internet. ',
          Link(to:'login', 'Please try again.')
      p 'We were not able to send you an email. To try again please go back to the ',
        Link(to:'login', 'login page.')
