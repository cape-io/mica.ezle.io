React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'
{Navigation} = require 'react-router'

module.exports = React.createClass
  # getInitialState: ->
  mixins: [Navigation]
  componentWillMount: ->
    app.me.email = @props.params.uid
    app.me.tempToken = @props.params.tempToken
    app.me.on 'change:loggedIn', (usr, loggedIn) =>
      if loggedIn
        @transitionTo 'img'
    app.me.on 'change:msgId', (usr, msgId) =>
      @transitionTo 'emailPending'

  componentWillUnmount: ->
    app.me.off 'change:msgId'
    app.me.off 'change:loggedIn'

  render: ->
    div null,
      p className: 'lead text-info',
        'One moment please... We are grabbing your artwork information.'
