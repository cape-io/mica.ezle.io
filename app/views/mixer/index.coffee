React = require 'react'
{h1, div, p, img} = require 'reactionary'
{Navigation} = require 'react-router'
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
        img
          className: 'logo'
          src: 'logo.png'
        h1 'Mixer'
        p
          className: 'lead',
            'MICA Grad Show 2015'
        Navbar null,
          Nav null,
            NavItem
              key: 'profile',
              href: @makeHref('editProfile'),
                'Profile'
            NavItem
              key: 'image'
              href: @makeHref('editImgs'),
                'Images'
            NavItem
              key: 'embed'
              href: @makeHref('editEmbed'),
                'Video/Audio/Etc.'
            NavItem
              key: 'essay'
              href: @makeHref('editEssay'),
                'Essay PDF'

        @props.activeRouteHandler(user: user)
