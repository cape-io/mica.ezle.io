Model = require("ampersand-model")

module.exports = Model.extend
  idAttribute: 'fileName'
  props:
    fileName: 'string'
    bytes: 'number'
    type: 'string'
    uploaded: 'boolean'
  session:
    file: 'object'
    progress: 'number'
    fileData: 'string'

  initialize: ->
    @on 'add', @processImgFile
    @on 'change:src', ->
      console.log 'has src'
    return

  derived:
    src:
      deps: ['fileData', 'uploaded']
      fn: ->
        if @uploaded
          # Final URL.
          return @createSrcUrl()
        else if @fileData
          # Base64
          return @fileData
        else
          # Loading graphic.
          return '//media.giphy.com/media/hI6MSx3lJFWko/giphy.gif'

  createSrcUrl: ->
    '//mica2015.imgix.net'+app.uploadInfo.prefix+@fileName+'?w=400'

  parse: (img) ->
    if img.file
      img.bytes = img.file.size
      img.type = img.file.type
    return img

  processImgFile: ->
    if @type.indexOf("image") is 0 and 3000000 > @bytes
      reader = new FileReader()
      reader.onload = (e) =>
        @fileData = e.target.result
        @uploadFile()
        return
      reader.readAsDataURL @file
    else
      @uploadFile()

  handleFinish: (e) ->
    if xhr.readyState is 4
      progress.className = ((if xhr.status is 200 then "success" else "failure"))
    return

  uploadFile: ->
    xhr = new XMLHttpRequest()
    handleProgress = (e) =>
      @progress = parseInt(e.loaded / e.total * 100)
    xhr.upload.addEventListener "progress", handleProgress, false
    xhr.onreadystatechange = (e) =>
      if xhr.readyState is 4
        if xhr.status is 201
          console.log 'uploaded img'
          itemImg = new Image()
          itemImg.onload = =>
            @uploaded = true
            console.log 'resized img'
          itemImg.src = @createSrcUrl()
        else
          console.log 'Error uploading file.'

    formData = new FormData()
    up = app.uploadInfo
    #formData.append('redirect', @state.redirect)
    formData.append('max_file_size', up.max_file_size)
    formData.append('max_file_count', up.max_file_count)
    formData.append('expires', up.expires)
    formData.append('signature', up.signature)
    formData.append('file1', @file)

    xhr.open 'POST', up.url, true
    xhr.send formData
