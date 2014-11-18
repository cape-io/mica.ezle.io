React = require 'react'
{ul, div} = require 'reactionary'

Img = require './img'

module.exports = React.createClass
  # getInitialState: ->

  componentDidMount: ->
    app.me.files.on 'change:uploaded', @handleFileUpload

  componentWillUnmount: ->
    app.me.files.off 'change:uploaded', @handleFileUpload

  handleFileUpload: ->
    console.log 'uploaded another image.'
    @setState filesUploaded: app.me.files.where(uploaded: false).length

  render: ->
    user = @props.user
    if user.files and user.files.length
      imageItems = []
      user.files.where(uploaded: true).forEach (imageInfo) ->
        imageItems.push Img(
          key: imageInfo.fileName
          model: imageInfo
          data: dragging: false
        )
    else
      imageItems = 'No images uploaded.'
    ul
      className: 'row uploaded',
        imageItems
