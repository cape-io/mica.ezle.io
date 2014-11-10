React = require 'react'
{h1, div, li, p} = require 'reactionary'
{Navigation, Link} = require 'react-router'
{Nav, Navbar, NavItem} = require 'react-bootstrap'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation]

  handleLogin: (usr, loggedIn) ->
    if loggedIn
      @forceUpdate()

  componentWillMount: ->
    app.me.on 'change:loggedIn', @handleLogin
    return

  componentWillUnmount: ->
    app.me.off 'change:loggedIn', @handleLogin

  render: ->
    if @props.params.uid
      user = _.find app.users, {uid: @props.params.uid}
    else
      user = app.me

    div
      className: 'row',
        h1 'Mixer'
        p
          className: 'lead',
            'MICA Grad Show 2015'
        Navbar null,
          Nav null,
            li null,
              Link
                key: 'profile',
                to: 'editProfile',
                  'Profile'
            li null,
              Link
                key: 'image'
                to: 'editImgs',
                  'Images'
            li null,
              Link
                key: 'embed'
                to: 'editEmbed',
                  'Video/Audio/Etc.'
            li null,
              Link
                key: 'essay'
                to: 'editEssay',
                  'Essay PDF'

        @props.activeRouteHandler(user: user)
