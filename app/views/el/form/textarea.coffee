React = require 'react'
{div, textarea, span} = require 'reactionary'
md = require 'marked'
module.exports = React.createClass

  getInitialState: ->
    value: 'Type some *markdown* here!'

  propTypes:
    id: React.PropTypes.string.isRequired
    fieldType: React.PropTypes.string.isRequired
    placeholder: React.PropTypes.string

  setMarkdown: ->
    @setState value: @refs[@props.id].getDOMNode().value

  render: ->
    div
      className: 'form-group',
        div
          className: 'col-md-8',
            textarea
              className: 'form-control'
              id: @props.id
              ref: @props.id
              value: @state.value
              onChange: @setMarkdown
              type: @props.fieldType
              placeholder: @props.placeholder
            span
              className: 'help-block',
                @props.help
        div
          className: 'markdown-content',
          dangerouslySetInnerHTML:
            __html: md @state.value
