React = require 'react'
{div, p, form, fieldset, img} = require 'reactionary'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

data = require '../models/student.yaml'
Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'

module.exports = React.createClass

  render: ->
    fields = []
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
        form
          className: 'form-horizontal',
            fieldset {},
              div
                className: 'student-input',
                  fields
                  Input
                    type: 'submit'
                    onClick: (e) ->
                      e.preventDefault()
                      app.container.router.redirectTo('form/imgs')
