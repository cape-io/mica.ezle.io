React = require 'react'
{li, img} = require 'reactionary'

cdn = 'https://mica2015.imgix.net/'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    li
      className: 'col-md-2',
        img
          className: 'img-thumbnail'
          src: cdn+@props.fileName+'?w=200&h=200&fit=crop'
          alt: @props.md5
          width: '150'
          height: '150'
