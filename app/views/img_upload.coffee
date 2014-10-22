React = require 'react/addons'
cx = React.addons.classSet
{div, p, form, fieldset, label, legend, img, button, input, br} = require 'reactionary'
#Input = require 'react-bootstrap/Input'

agent = require 'superagent'

module.exports = React.createClass
  getInitialState: ->
    loading: true
    url: 'https://storage101.ord1.clouddrive.com/v1/MossoCloudFS_3525662f-4803-4423-aabf-7f69aaaaa557/mica-2014/u1'
    redirect: 'http://www.kaicurry.com'
    max_file_size: '52428800'
    max_file_count: '50'
    expires: '1413833194'
    signature: ''
    fileHover: false
    files: null

  handleFileSelect: (e) ->
    # Disable defaults. Toggle off 'hover' class.
    @handleFileHover(e)
    # Fetch file list object.
    files = e.target.files or e.dataTransfer.files
    # Process the files
    fileArray = []
    fileArray.push file for file in files
    @setState files: fileArray
    fileArray.forEach (file, i) =>
      @parseFile file, i
      @uploadFile file

  parseFile: (file, i) ->
    if file.type.indexOf("image") is 0
      reader = new FileReader()
      reader.onload = (e) =>
        imgs = @state.files
        imgs[i].src = e.target.result
        @setState files: imgs
        return
      reader.readAsDataURL file

  uploadFile: (file) ->
    xhr = new XMLHttpRequest()
    formData = new FormData()
    #formData.append('redirect', @state.redirect)
    formData.append('max_file_size', @state.max_file_size)
    formData.append('max_file_count', @state.max_file_count)
    formData.append('expires', @state.expires)
    formData.append('signature', @state.signature)
    formData.append('file1', file)

    xhr.open 'POST', @state.url, true
    xhr.send formData

  # This is mostly just to set the hover class.
  handleFileHover: (e) ->
    if e.preventDefault then e.preventDefault()
    if e.stopPropagation then e.stopPropagation()
    if e.type == 'dragover'
      if not @state.fileHover
        @setState fileHover: true
    else if @state.fileHover == true
      @setState fileHover: false
    return

  componentWillMount: ->
    agent.get 'http://cf.webscript.io/token?folder=kai', (res) =>
      res.body.loading = false
      @setState res.body

  componentDidMount: ->
    fileselect = @refs.fileselect.getDOMNode()
    filedrag = @refs.filedrag.getDOMNode()
    submitbutton = @refs.submitbutton.getDOMNode()
    # File select.

  renderFile: (file) ->
    if file.src
      image =
        img
          src: file.src
          width: '400'
    else
      image = false
    p
      key: file.key,
        'File name: '+file.name+' type: '+file.type+' size: '+file.size+' bytes'
        image

  render: ->
    if @state.loading
      msg = 'Getting upload creds from server.'
    else
      msg = 'Upload creds received. '+@state.signature
    if @state.files
      files = @state.files.map (file) =>
        file.key = file.name
        @renderFile(file)
      # console.log @state.files[0].name
      # files = p 'files'
    else
      files = p 'No files yet.'
    div null,
      form
        method: 'POST'
        action: @state.url
        encType: 'multipart/form-data'
        className: 'form-horizontal',
          fieldset null,
            legend 'HTML File Upload'
            # input
            #   type: 'hidden'
            #   name: 'redirect'
            #   value: @state.redirect
            input
              type: 'hidden'
              name: 'max_file_size'
              value: @state.max_file_size
            input
              type: 'hidden'
              name: 'max_file_count'
              value: @state.max_file_count
            input
              type: 'hidden'
              name: 'expires'
              value: @state.expires
            input
              type: 'hidden'
              name: 'signature'
              value: @state.signature
            div
              className: 'dropzone',
                label
                  htmlFor: 'fileselect',
                    'Files to upload:'
                input
                  type: 'file'
                  id: 'fileselect'
                  ref: 'fileselect'
                  name: 'fileselect[]'
                  multiple: 'multiple'
                  accept: 'image/jpg, image/jpeg'
                  onChange: @handleFileSelect
                div
                  ref: 'filedrag'
                  onDragOver: @handleFileHover
                  onDragLeave: @handleFileHover
                  onDrop: @handleFileSelect
                  className: cx(hover: @state.fileHover)
                  id: 'filedrag',
                    'or drop', br(null), 'files here'
            div
              ref: 'submitbutton'
              #style: {display: 'none'}
              id: 'submitbutton',
                button
                  type: 'submit',
                    'Upload Files'
      files
      p msg
