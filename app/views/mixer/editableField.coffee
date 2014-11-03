React = require 'react/addons'
cx = React.addons.classSet
{div} = require 'reactionary'

module.exports = React.createClass

  render: ->
    buttonClasses = cx
      'col-md-4': true
      'form-value': true
      'editable-click': true
      'required': @props.required
      'editable-empty': !@props.value

    fieldValue = @props.value or 'Empty'

    div
      id: @props.id
      className: 'editable form-group',
        div
          className: 'col-md-4 text-right',
            @props.label
        a
          role: 'button'
          onClick: =>
            @props.editField @props.id
          className: buttonClasses,
            fieldValue
