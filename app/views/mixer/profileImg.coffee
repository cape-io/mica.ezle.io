React = require 'react'
{div, img} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->
  createImg: (id, url) ->
    img
      className: 'col-md-2 click'
      key: id
      src: url
      onClick: ->
        app.me.save pic: url
      # width: '100'
      # height: '100'

  render: ->
    model = @props.model
    pics = []
    pics.push @createImg('gravatar', 'https://www.gravatar.com/avatar/'+model.emailHash+'?d=retro&s=300')

    if model.twitter
      pics.push @createImg('twitter', 'https://avatars.io/twitter/'+model.twitter+'?size=large')

    if model.facebook
      pics.push @createImg('facebook', 'https://avatars.io/facebook/'+model.facebook+'?size=large')

    if model.instagram
      pics.push @createImg('instagram', 'https://avatars.io/instagram/'+model.instagram+'?size=large')

    div
      className: 'row',
        pics
