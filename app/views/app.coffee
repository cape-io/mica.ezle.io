React = require 'react'
{h1, div, p} = require 'reactionary'
{Navigation, CurrentPath} = require 'react-router'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation, CurrentPath]
  render: ->
    #console.log RouteContext
    div
      className: 'container '+@getCurrentPath().substring(1).replace('/', '-'),
        @props.activeRouteHandler(null)
