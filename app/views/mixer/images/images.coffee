React = require 'react'
{ul, div} = require 'reactionary'
_ = require 'lodash'
Img = require './img'

# List of uploaded images.

module.exports = React.createClass
  getInitialState: ->
    items: @props.items
    dragging: undefined

  handleSort: (items, dragging) ->
    if dragging == undefined
      #console.log items
      # Update the parent component that has access to the collection.
      @props.handleSort items
    # Always update the state of this component.
    @setState
      items: items
      dragging: dragging

  componentWillReceiveProps: (nextProps) ->
    @setState
      items: nextProps.items

  render: ->
    items = @state.items
    imageItems = items.map (id, i) =>
      model = _.find @props.collection, {fileName: id}
      Img
        key: i
        model: model
        data:
          items: @state.items
          dragging: @state.dragging
        sort: @handleSort

    ul
      className: 'row uploaded',
        imageItems
