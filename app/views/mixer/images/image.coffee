React = require 'react/addons'
cx = React.addons.classSet
{div, h2} = require 'reactionary'

_ = require 'lodash'

ImageUpload = require './imageUpload'
ImageUploads = require './images'
ImageNoUploads = require './imgNoUploads'

# Images index view.

module.exports = React.createClass
  getInitialState: ->
    @getItems()

  collections: {
    uploaded: []
    uploading: []
  }

  getItems: () ->
    user = @props.user
    if user.files and user.files.length
      @collections =
        uploaded: user.files.where(uploaded: true)
        uploading: user.files.where(uploaded: false)
    else
      @collections =
        uploaded: []
        uploading: []
    uploaded: @collections.uploaded.length
    uploading: @collections.uploading.length

  componentDidMount: ->
    app.me.files.on 'change:uploaded', @handleFileUpload
    app.me.files.on 'remove', @handleFileUpload
    # app.me.files.on 'all', (a, b, c) ->
    #   console.log a, b, c

  componentWillUnmount: ->
    app.me.files.off 'change:uploaded', @handleFileUpload
    app.me.files.off 'remove', @handleFileUpload

  handleFileUpload: ->
    st = @getItems()
    console.log st, 'collection change'
    # Update state object with latest items.
    @setState st

  handleSort: (items) ->
    items.forEach (id, i) =>
      @props.user.files.get(id).metadata.sortOrder = i
    @props.user.files.sort()
    @props.user.save()

  render: ->
    if @collections.uploaded.length
      uploadedImgs = ImageUploads
        collection: @collections.uploaded
        items: _.pluck @collections.uploaded, 'fileName'
        handleSort: @handleSort
    else
      uploadedImgs = ImageNoUploads null

    div
      className: 'images',
        @props.activeRouteHandler(null)
        ImageUpload @props
        h2 'Uploaded Images'
        uploadedImgs
