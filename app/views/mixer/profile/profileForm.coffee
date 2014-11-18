React = require 'react'
{div, h2, p, form, fieldset, img} = require 'reactionary'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

editableField = require '../editableField'

data = require '../../../data/studentSchema'

module.exports = React.createClass
  getInitialState: ->
    editField: null

  handleChange: (newSt) ->
    @setState newSt

  editField: (fieldId) ->
    @setState editField: fieldId

  handleFieldSubmit: (fieldId, value) ->
    app.me.save fieldId, value

  render: ->
    user = @props.user
    fields = []
    # Static email field.
    fields.push editableField
      key: 'email'
      id: 'email'
      label: 'MICA Email'
      editable: false
      value: user.email

    _.forEach data.props, (field, fieldId) =>
      if field.label
        props = field
        props.key = fieldId
        props.id = fieldId
        props.value = user[fieldId]
        props.editField = @editField
        props.onSubmit = @handleFieldSubmit
        props.editing = @state.editField == fieldId
        props.user = user
        fieldEl = editableField props
        fields.push fieldEl

    div
      className: 'student-input',
        fields
