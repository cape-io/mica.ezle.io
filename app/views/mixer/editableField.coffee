React = require 'react/addons'
cx = React.addons.classSet
{div, a, span, img} = require 'reactionary'
_ = require 'lodash'
md = require 'marked'

EditField = require './editField'

module.exports = React.createClass

  render: ->
    # Determine if field is editable.
    fieldIsEditable = @props.editable != false

    # Assign value to fieldValue variable.
    fieldValue = @props.value
    if fieldValue
      if @props.options
        if val = _.find(@props.options, value: fieldValue)
          fieldValue = val.name
      if @props.element == 'textarea'
        fieldValue = span
          className: 'markdown'
          dangerouslySetInnerHTML:
            __html: md fieldValue
      if @props.id == 'pic'
        fieldValue = img
          src: fieldValue
          alt: 'Profile Picture'
      else if @props.id == 'size'
        fieldValue = @props.model.sizeDisplay
    else
      fieldValue = 'Empty'
    # Calculate classes for the value Element.
    buttonClasses = cx
      'col-md-8': true
      'form-value': true
      'editable-click': fieldIsEditable
      'required': @props.required
      'editable-empty': !@props.value

    rowClasses = cx
      'editable': fieldIsEditable
      'form-group': true

    # Value element.
    if fieldIsEditable
      if @props.editing
        valueEl = EditField @props
      else
        valueEl = a
          role: 'button'
          onClick: =>
            @props.editField @props.id
          className: buttonClasses,
            fieldValue
    else # Fixed value.
      valueEl = div
        className: buttonClasses,
          fieldValue

    # RENDER
    div
      id: @props.id
      className: rowClasses,
        div
          className: 'col-md-2 text-right',
            @props.label
        valueEl
