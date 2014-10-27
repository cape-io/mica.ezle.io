React = require 'react'
{h1, div, p} = require 'reactionary'
{Navigation, CurrentPath} = require 'react-router'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation, CurrentPath]
  render: ->
    #console.log RouteContext
    div
      className: 'row',
        div
          className: 'col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3',
            h1 'Login'
            p
              className: 'lead',
                'MICA Grad Show 2015'
            @props.activeRouteHandler(null)
