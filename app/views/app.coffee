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
          className: 'feedback'
          target: '_blank'
          href: 'http://www.hipchat.com/g4oN9THPy',
            button
              className: 'btn btn-info',
                'Feedback'
            p
              className: 'helptext',
                'If you have a question, an issue uploading, or have noticed a bug, please report it here'
