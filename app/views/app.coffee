React = require 'react'
{h1, div, p, a, button} = require 'reactionary'
{Navigation, CurrentPath} = require 'react-router'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation, CurrentPath]
  render: ->
    #console.log RouteContext
    div
      className: 'container '+@getCurrentPath().substring(1).replace('/', '-'),
        @props.activeRouteHandler(null)
        a
          target: '_blank'
          href: 'http://www.hipchat.com/g4oN9THPy',
            button
              className: 'btn btn-info',
                'Feedback'
