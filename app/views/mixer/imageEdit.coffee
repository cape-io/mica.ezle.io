React = require 'react'
{h1, div, form, fieldset, p, a} = require 'reactionary'
_ = require 'lodash'

data = require '../../models/photo.yaml'
editableField = require './editableField'

module.exports = React.createClass
  getInitialState: ->
    editField: null

  editField: (fieldId) ->
    @setState editField: fieldId

  render: ->
    fileName = @props.params.splat

    fields = []
    _.forEach data.props, (field, fieldId) =>
      if field.label
        props = field
        props.key = fieldId
        props.id = fieldId
        #props.value = user[fieldId]
        props.editField = @editField
        props.editing = @state.editField == fieldId
        fieldEl = editableField props
        fields.push fieldEl

    div null,
      form
        className: 'form-horizontal',
          fieldset {},
            fields
      p className: 'lead text-info',
        'Individual image update. ' + fileName
