React = require 'react'
{div, h2, p, form, fieldset, img} = require 'reactionary'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

editableField = require './editableField'

data = require '../../data/studentSchema'
Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'

module.exports = React.createClass
  getInitialState: ->
    editField: null

  handleChange: (newSt) ->
    @setState newSt

  editField: (fieldId) ->
    @setState editField: fieldId

  render: ->
    if @props.params.uid
      user = _.find app.users, {uid: @props.params.uid}
    else
      user = app.me

    fields = []
    # Static email field.
    fields.push editableField
      key: 'email'
      id: 'email'
      label: 'MICA Email'
      editable: false
      value: user.email

    fieldIds = _.keys data.props

    _.forEach data.props, (field, fieldId) =>
      if field.label
        props = field
        props.key = fieldId
        props.id = fieldId
        props.value = user[fieldId]
        props.editField = @editField
        props.editing = @state.editField == fieldId
        fieldEl = editableField props
        fields.push fieldEl

    div
      className: 'student-input',
        fields
