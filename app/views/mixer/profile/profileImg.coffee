React = require 'react'
{div, img} = require 'reactionary'

module.exports = React.createClass
  getInitialState: ->
    active: null

  createImg: (id, url) ->
    imgClassName = 'click'
    if @state.active == id or @props.value == url
      imgClassName += ' active img-thumbnail'
    img
      className: imgClassName
      key: id
      src: url
      onClick: =>
        @props.setValue url
        @setState active: id
        #app.me.save pic: url
      # width: '100'
      # height: '100'

  render: ->
    model = @props.model
    pics = []
    pics.push @createImg('gravatar', model.gravatar)

    if model.twitter
      pics.push @createImg('twitter', 'https://avatars.io/twitter/'+model.twitter+'?size=large')

    if model.facebook
      pics.push @createImg('facebook', 'https://avatars.io/facebook/'+model.facebook+'?size=large')

    if model.instagram
      pics.push @createImg('instagram', 'https://avatars.io/instagram/'+model.instagram+'?size=large')

    div
      className: 'profilepics col-md-4',
        pics
