React = require 'react'
{ul, div} = require 'reactionary'
_ = require 'lodash'
Img = require './img'

# List of uploaded images.

module.exports = React.createClass
  getInitialState: ->
    items = @props.items
    data:
      items: items
      dragging: undefined

  handleSort: (items, dragging) ->
    data = @state.data
    data.items = items
    data.dragging = dragging
    if dragging == undefined
      #console.log items
      @props.handleSort items
    @setState data: data

  render: ->
    items = @state.data.items
    # @props.items.forEach (id) ->
    #   unless _.contains items, id
    #     items.push id
    imageItems = items.map (id, i) =>
      model = _.find @props.collection, {fileName: id}
      Img
        key: i
        model: model
        data: @state.data
        sort: @handleSort

    ul
      className: 'row uploaded',
        imageItems
