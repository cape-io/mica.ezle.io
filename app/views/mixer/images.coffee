React = require 'react'
{ul, div} = require 'reactionary'

Img = require './img'

module.exports = React.createClass
  # getInitialState: ->
  render: ->
    user = @props.user
    if user.files and user.files.length
      imageItems = []
      user.files.forEach (imageInfo) ->
        imageItems.push Img(key: imageInfo.fileName, model: imageInfo)
    else
      imageItems = 'No images uploaded.'
    ul
      className: 'row uploaded',
        imageItems
