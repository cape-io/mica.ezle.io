React = require 'react/addons'
cx = React.addons.classSet
{div, ag} = require 'reactionary'

module.exports = React.createClass

  render: ->
    # Determine if field is editable.
    fieldIsEditable = @props.editable != false

    # Assign value to fieldValue variable.
    fieldValue = @props.value or 'Empty'
    if fieldValue and @props.options and @props.options[fieldValue]
      fieldValue = @props.options[fieldValue]

    # Calculate classes for the value Element.
    buttonClasses = cx
      'col-md-4': true
      'form-value': true
      'editable-click': fieldIsEditable
      'required': @props.required
      'editable-empty': !@props.value

    rowClasses = cx
      'editable': fieldIsEditable
      'form-group': true

    # Value element.
    if fieldIsEditable
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
          className: 'col-md-4 text-right',
            @props.label
        valueEl
