React = require 'react'
{div, p} = require 'reactionary'

data = require '../models/student.yaml'

module.exports = React.createClass

  render: ->

    div
      id: 'container-collection'
      className: 'collection',
        p
          key: 'intro'
          className: 'text-area',
            data.props.mica_email.type
