React = require 'react'
{div, p} = require 'reactionary'
_ = require 'lodash'

data = require '../models/student.yaml'
Text = require '../el/form/text'

module.exports = React.createClass

  render: ->
    fields = []
    _.forEach data.props, (field, fieldId) ->
      if field.element == 'text' or field.element == 'email'
        fields.push Text
          key: fieldId
          id: fieldId
          label: field.label
          placeholder: field.placeholder
          help: field.help
          fieldType: field.element
    div
      id: 'container-collection'
      className: 'collection',
        fields
