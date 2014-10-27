React = require 'react'
{h1, div, p} = require 'reactionary'
{Navigation} = require 'react-router'
{Nav, Navbar, NavItem} = require 'react-bootstrap'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation]
  render: ->
    #console.log RouteContext
    div
      className: 'row',
        h1 'Mixer'
        p
          className: 'lead',
            'MICA Grad Show 2015'
        Navbar
          NavItem
            key: 'profile'
            href: @makePath 'editProfile'
          NavItem
            key: 'image'
            href: @makePath 'editImgs'
          NavItem
            key: 'embed'
            href: @makePath 'editEmbed'

        @props.activeRouteHandler(null)
