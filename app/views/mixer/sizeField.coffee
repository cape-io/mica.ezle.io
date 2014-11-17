React = require 'react'
{div, select, option, label, span, input, p, form} = require 'reactionary'
_ = require 'lodash'

module.exports = React.createClass

  getInitialState: ->
    value: @props.value

  propTypes:
    id: React.PropTypes.string.isRequired

  handleSizeType: (e) ->
    console.log 'handleSizeType'
    val = e.target.value
    @setState value: val
    @props.onChange(e)

  handleSizeChange: ->
    h = @refs.height.getDOMNode().value.replace /[^0-9.]/, ''
    w = @refs.width.getDOMNode().value.replace /[^0-9.]/, ''
    d = @refs.depth.getDOMNode().value.replace /[^0-9.]/, ''
    val = 'size-'+h+'x'+w+'x'+d
    @setState value: val
    @props.onChange({target: {value: val}})

  parseSize: (str) ->
    if str == 'fixed'
      return h: null, w: null, d: null
    size = str.replace('size-', '').split('x')
    h: size[0]
    w: size[1]
    d: size[2]

  render: ->
    val = SelectVal = @state.value
    optSelect =
      value: 'x'
      name: 'Select...'
    optNone =
      value: 'none'
      name: 'Not applicable'
    optVariable =
      value: 'variable'
      name: 'Variable'
    optFixed =
      value: 'fixed'
      name: 'Specific Dimensions'
    ops = [optSelect, optNone, optVariable, optFixed]

    options = []
    ops.forEach (opt) ->
      options.push option
        key: opt.value
        value: opt.value,
          opt.name

    selectOps = _.pluck(ops, 'value')

    if val and (val == 'fixed' or not _.contains selectOps, val)
      SelectVal = 'fixed'
      sizeVals = @parseSize(val)
      sizeFields = form
        role: 'form',
          div
            className: 'row dimensions',
              div
                className: 'form-control height',
                  input
                    type: 'text'
                    className: 'form-control'
                    placeholder: 'H'
                    ref: 'height'
                    onChange: @handleSizeChange
                    value: sizeVals.h
                  span
                    className: "input-group-addon plain",
                      'in'
                  span
                    className: "input-group-addon plain bythis",
                      '×'
              div
                className: 'form-control width',
                  input
                    type: 'text'
                    className: 'form-control'
                    placeholder: 'W'
                    ref: 'width'
                    onChange: @handleSizeChange
                    value: sizeVals.w
                  span
                    className: "input-group-addon plain",
                      'in'
                  span
                    className: "input-group-addon plain bythis",
                      '×'
              div
                className: 'form-control depth',
                  input
                    type: 'text'
                    className: 'form-control'
                    placeholder: 'D'
                    ref: 'depth'
                    onChange: @handleSizeChange
                    value: sizeVals.d
                  span
                    className: "input-group-addon plain",
                      'in '
    else
      sizeFields = false

    selectField = select
      value: SelectVal
      onChange: @handleSizeType
      type: 'select',
        options

    div
      className: 'size-field',
        div
          className: 'col-md-8',
            selectField
            sizeFields
            span
              className: 'help-block',
                @props.help
