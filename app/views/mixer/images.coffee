React = require 'react'
{ul, div} = require 'reactionary'

Img = require './img'

module.exports = React.createClass
  # getInitialState: ->
  render: ->
    user = @props.user
    if user.files and user.files[0]
      imageItems = []
      user.files.forEach (imageInfo) ->
        imageInfo.key = imageInfo.fileName
        imageItems.push Img(imageInfo)
    else
      imageItems = 'No images uploaded.'
    ul
      className: 'row uploaded',
        imageItems
