React = require 'react'
{div, p, form, fieldset} = require 'reactionary'
_ = require 'lodash'

data = require '../models/student.yaml'
Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'

module.exports = React.createClass

  render: ->
    fields = []
    _.forEach data.props, (field, fieldId) ->
      props =
        key: fieldId
        id: fieldId
        label: field.label
        placeholder: field.placeholder
        help: field.help
        fieldType: field.element
        options: field.options
      if _.contains ['text', 'email'], field.element
        fields.push Text props
      else if field.element == 'select'
        fields.push Select props
      else if field.element == 'textarea'
        fields.push TextArea props

    form
      className: 'form-horizontal',
        fieldset {},
          div
            id: 'container-collection'
            className: 'collection',
              fields
