React = require 'react'
{div, span, input, textarea, button, i} = require 'reactionary'
_ = require 'lodash'

Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'

ProfileImg = require './profileImg'

module.exports = React.createClass

  #mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    value: @props.value

  componentDidMount: ->
    @refs.fieldInput.getDOMNode().focus()

  setValue: (newVal) ->
    @setState value: newVal

  render: ->
    field = @props
    fieldId = field.id
    formFieldProps =
      className: 'form-control input-sm'
      value: @state.value
      ref: 'fieldInput'
      id: fieldId
      placeholder: field.placeholder
      help: field.help
      fieldType: field.element
      options: field.options
      onChange: (e) =>
        @setValue e.target.value

    if _.contains ['text', 'email'], field.element
      formFieldEl = input formFieldProps
    else if field.element == 'select'
      formFieldEl = Select formFieldProps
    else if field.element == 'textarea'
      formFieldEl = textarea formFieldProps

    if fieldId == 'pic'
      extraEl = ProfileImg
        model: @props.user
        setValue: @setValue
        value: @state.value
    else
      extraEl = false

    div
      className: 'form-inline editableform',
        extraEl
        div
          className: 'editable-input',
            formFieldEl
            span
              className: 'editable-clear-x'
        div
          className: 'editable-buttons',
            button
              className: 'btn btn-primary btn-sm editable-submit'
              onClick: (e) =>
                e.preventDefault()
                newVal = {}
                newVal[@props.id] = @state.value
                app.me.save newVal
                @props.editField null
              type: 'submit',
                i
                  className: 'glyphicon glyphicon-ok'
            button
              className: 'btn btn-default btn-sm editable-submit'
              onClick: => @props.editField null
              type: 'button',
                i
                  className: 'glyphicon glyphicon-remove'
