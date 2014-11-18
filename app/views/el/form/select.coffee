React = require 'react'
{div, select, option, label, span} = require 'reactionary'

module.exports = React.createClass

  propTypes:
    id: React.PropTypes.string.isRequired
    options: React.PropTypes.array.isRequired

  render: ->
    options = []
    @props.options.forEach (opt) ->
      options.push option
        key: opt.value
        value: opt.value,
          opt.name
    div
      className: 'form-group',
        div
          className: 'col-md-8',
            select
              value: @props.value
              onChange: @props.onChange
              type: 'select',
                options
            span
              className: 'help-block',
                @props.help
