React = require 'react/addons'
cx = React.addons.classSet
{div, h2, a, small, input, img, p} = require 'reactionary'
_ = require 'lodash'

ImageUploading = require '../images/imageUploading'

module.exports = React.createClass
  getInitialState: ->
    fileHover: false
    filesUploading: 0

  componentDidMount: ->
    # Every time an images changes its src update the view.
    app.me.files.on 'add', @handleFileUpload
    #app.me.files.on 'change:uploaded', @handleFileUpload
    app.me.on 'change:pic', @handleFileUpload

  componentWillUnmount: ->
    app.me.files.off 'add', @handleFileUpload
    #app.me.files.off 'change:uploaded', @handleFileUpload
    app.me.on 'change:pic', @handleFileUpload

  handleFileUpload: ->
    if @isMounted()
      @setState filesUploading: app.me.files.where(uploaded: false).length
    log
      console.log 'not mounted. wtf error.'

  # This is just to set the hover class.
  handleFileHover: (e) ->
    if e.preventDefault then e.preventDefault()
    if e.stopPropagation then e.stopPropagation()
    if e.type == 'dragover'
      e.dataTransfer.dropEffect = 'copy'
      if not @state.fileHover
        @setState fileHover: true
    else if @state.fileHover == true
      @setState fileHover: false
    return

  # Drop or Select
  handleFileSelect: (e) ->
    # Disable defaults. Toggle off 'hover' class.
    @handleFileHover(e)
    # Delete current profile image.
    if app.me.picFileName
      picModel = app.me.files.get(app.me.picFileName)
      if picModel then picModel.destroy()

    # Fetch file list object.
    files = e.target.files or e.dataTransfer.files
    maxFilesReached = false
    # Process the files
    addFile = (file) ->
      fileName = app.me.uploadInfo.prefix.substr(1)+file.name
      validImgTypes = ['image/jpg', 'image/jpeg']
      isImg = _.contains validImgTypes, file.type
      if isImg
        app.me.files.add
          metadata: {id: fileName, profilePic: true, title: 'Profile Picture'}
          file: file
          fileName: fileName,
            parse: true
      else
        console.log file.type
        alert 'Please upload JPGs or GIFs, not a '+ file.type.split('/')[1].toUpperCase() + '.
          The system does not handle image files of this type. Please save this as a JPG from
          the program you used to create this. Ask a friend if you need help.'
      return
    addFile files[0]
    if maxFilesReached
      alert 'You are limited to 25 images. Please delete some images before adding more.'
    return

  activateFileSelect: ->
    @refs.fileselect.getDOMNode().click()

  render: ->
    if @state.filesUploading
      console.log 'files uploading now. show them.'
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
        #jumbotron: true
        dropzone: true
      )
      ref: 'filedrag'
      onDragOver: @handleFileHover
      onDragLeave: @handleFileHover
      onDrop: @handleFileSelect
      onClick: @activateFileSelect
      id: 'filedrag',
        if files then files else img
          src: app.me.pic
          alt: 'Profile Picture'
        p
          'Click on the image or drop a new JPG on top of it to replace it.'
        input
          type: 'file'
          id: 'fileselect'
          ref: 'fileselect'
          name: 'fileselect'
          accept: 'image/jpg, image/jpeg'
          onChange: @handleFileSelect
          style:
            display: 'none'
