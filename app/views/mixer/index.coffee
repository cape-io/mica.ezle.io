React = require 'react'
{h1, div, p} = require 'reactionary'
{Navigation} = require 'react-router'
{Nav, Navbar, NavItem} = require 'react-bootstrap'

module.exports = React.createClass
  #getInitialState: ->
  mixins: [Navigation]
  render: ->
    div
      className: 'row',
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

        @props.activeRouteHandler(null)
