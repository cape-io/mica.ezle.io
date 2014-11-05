React = require 'react'
{div, h2, form, fieldset} = require 'reactionary'

ProfileForm = require './profileForm'

module.exports = React.createClass

  render: ->
    div
      className: 'artist-input',
        h2 'Student Info'
        form
          className: 'form-horizontal',
            fieldset {},
              ProfileForm @props
