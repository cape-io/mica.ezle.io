React = require 'react/addons'
cx = React.addons.classSet
{div, h2, a, small, input} = require 'reactionary'

ImageUploading = require './imageUploading'

module.exports = React.createClass
  getInitialState: ->
    fileHover: false
    filesUploading: 0

  componentDidMount: ->
    # Every time an images changes its src update the view.
    app.me.files.on 'add', @handleFileUpload
    app.me.files.on 'change:uploaded', @handleFileUpload

  componentWillUnmount: ->
    app.me.files.off 'add', @handleFileUpload
    app.me.files.off 'change:uploaded', @handleFileUpload

  handleFileUpload: ->
    @setState filesUploading: app.me.files.where(uploaded: false).length

  # This is just to set the hover class.
  handleFileHover: (e) ->
    if e.preventDefault then e.preventDefault()
    if e.stopPropagation then e.stopPropagation()
    if e.type == 'dragover'
      if not @state.fileHover
        @setState fileHover: true
    else if @state.fileHover == true
      @setState fileHover: false
    return

  # Drop or Select
  handleFileSelect: (e) ->
    # Disable defaults. Toggle off 'hover' class.
    @handleFileHover(e)
    # Fetch file list object.
    files = e.target.files or e.dataTransfer.files
    # Process the files
    addFile = (file) ->
      fileName = app.me.uploadInfo.prefix.substr(1)+file.name
      app.me.files.add
        metadata: {id: fileName}
        file: file
        fileName: fileName,
          parse: true
    addFile file for file in files

  activateFileSelect: ->
    @refs.fileselect.getDOMNode().click()

  render: ->
    if @state.filesUploading
      files = []
      app.me.files.where(uploaded: false).forEach (imgUp) ->
        #console.log imgUp.fileName
        files.push ImageUploading
          key: imgUp.fileName
          model: imgUp
      files = div
        className: 'dz-images row',
          files
    else
      files = false
    div
      className: cx(
        hover: @state.fileHover
        'alert-info': @state.fileHover
        jumbotron: true
        dropzone: true
      )
      ref: 'filedrag'
      onDragOver: @handleFileHover
      onDragLeave: @handleFileHover
      onDrop: @handleFileSelect
      onClick: @activateFileSelect
      id: 'filedrag',
        h2 'Drop files ', small('to upload')
        a
          className: 'btn btn-primary btn-lg',
            'Or Click'
        files
        input
          type: 'file'
          id: 'fileselect'
          ref: 'fileselect'
          name: 'fileselect[]'
          multiple: 'multiple'
          accept: 'image/jpg, image/jpeg'
          onChange: @handleFileSelect
          style:
            display: 'none'
