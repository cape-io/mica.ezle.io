React = require 'react'
{div, h2, p, form, fieldset, img} = require 'reactionary'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

data = require '../../data/studentSchema'
Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'

module.exports = React.createClass

  render: ->
    if @props.params.uid
      user = _.find app.users, {uid: @props.params.uid}
    else
      user = app.me

    fields = []
    fields.push div
      key: 'mica-mail'
      className: 'form-group',
        div
          className: 'col-md-4 text-right',
            'MICA Email'
        div
          className: 'col-md-4 form-value',
            user.email
    _.forEach data.props, (field, fieldId) ->
      if fieldId == 'mica_email' then return
      props =
        key: fieldId
        id: fieldId
        label: field.label
        placeholder: field.placeholder
        help: field.help
        fieldType: field.element
        options: field.options
        value: user[fieldId]
      if _.contains ['text', 'email'], field.element
        fields.push Text props
      else if field.element == 'select'
        fields.push Select props
      else if field.element == 'textarea'
        fields.push TextArea props

    if @state and @state.imgSrc
      console.log 'lshow img'
      fields.push img
        key: 'img'
        src: @state.imgSrc
        alt: 'preview image'

    div
      className: 'artist-input',
        h2 'Student Info'
        form
          className: 'form-horizontal',
            fieldset {},
              div
                className: 'student-input',
                  fields
                  Input
                    type: 'submit'
