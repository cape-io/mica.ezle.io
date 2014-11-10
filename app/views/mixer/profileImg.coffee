React = require 'react'
{div, img} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    model = @props.model
    pics = []
    pics.push img
      className: 'col-md-2'
      key: 'gravatar'
      src: 'https://www.gravatar.com/avatar/'+model.emailHash+'?d=retro&s=300'
      width: '150'
    if model.twitter
      pics.push img
        className: 'col-md-2'
        key: 'twitter'
        src: 'https://avatars.io/twitter/'+model.twitter+'?size=large'
    if model.facebook
      pics.push img
        className: 'col-md-2'
        key: 'facebook'
        src: 'https://avatars.io/facebook/'+model.facebook+'?size=large'
    if model.instagram
      pics.push img
        className: 'col-md-2'
        key: 'instagram'
        src: 'https://avatars.io/instagram/'+model.instagram+'?size=large'

    div
      className: 'row',
        pics
