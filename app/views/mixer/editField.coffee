React = require 'react'
{div, span, input, textarea, button, i} = require 'reactionary'
_ = require 'lodash'

Text = require '../el/form/text'
TextArea = require '../el/form/textarea'
Select = require '../el/form/select'
SizeField = require './sizeField'
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
      className: 'form-control input-md'
      value: @state.value
      ref: 'fieldInput'
      id: fieldId
      placeholder: field.placeholder
      help: field.help
      fieldType: field.element
      options: field.options
      onChange: (e) =>
        @setValue e.target.value

    if 'size' == fieldId
      formFieldEl = SizeField formFieldProps
    else if _.contains ['text', 'email'], field.element
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
                e.preventDefault() # Prevent html form submit.
                # Save to model.
                val = @refs.fieldInput.getDOMNode().value or @state.value
                @props.onSubmit @props.id, val
                @props.editField null # Field isn't being edited.
              type: 'submit',
                i
                  className: 'glyphicon glyphicon-ok'
            button
              className: 'btn btn-default btn-sm editable-submit'
              onClick: => @props.editField null
              type: 'button',
                i
                  className: 'glyphicon glyphicon-remove'
        span
          className: 'help-block',
            @props.help
