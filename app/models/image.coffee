Model = require("ampersand-model")

CDN = '//mica2015.imgix.net/'

ImageMeta = require './imageMeta'

humanFileSize = (bytes, si) ->
  thresh = 1024
  if bytes < thresh
    return value: bytes, unit: "B"
  units = ["KiB", "MiB", "GiB"]
  u = -1
  loop
    bytes /= thresh
    ++u
    break unless bytes >= thresh
  return value: bytes.toFixed(1), unit: units[u]

module.exports = Model.extend
  idAttribute: 'fileName'
  url: ->
    app.api+'file/'+@fileName
  initialize: ->
    @on 'add', @processImgFile
    @on 'change:src', ->
      console.log 'has src'
    return
  props:
    fileName: 'string'
    bytes: 'number'
    type: 'string'
    uploaded: 'boolean'
    md5: 'string'
    lastModified: 'string'
  session:
    file: 'object'
    progress:
      type: 'number'
      default: 0
    fileData: 'string'
  children:
    metadata: ImageMeta
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

    humanSize:
      deps: ['bytes']
      fn: ->
        humanFileSize(@bytes)

    thumbSrc:
      deps: ['fileName']
      fn: ->
        CDN+@fileName+'?w=200&h=200&fit=crop'

    editUrl:
      deps: ['fileName']
      fn: ->
        '#/mixer/images'+@fileName.replace(app.me.uid, '')

  # Used when uploading only.
  createSrcUrl: () ->
    '//mica2015.imgix.net'+app.me.uploadInfo.prefix+@fileName+'?w=200'

  parse: (img) ->
    if img.file
      img.bytes = img.file.size
      img.type = img.file.type
    if img.md5
      img.uploaded = true
      img.progress = 100
    return img

  processImgFile: ->
    if @type and @file and @type.indexOf("image") is 0
      if 3000000 > @bytes
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
    up = app.me.uploadInfo
    #formData.append('redirect', @state.redirect)
    formData.append('max_file_size', up.max_file_size)
    formData.append('max_file_count', up.max_file_count)
    formData.append('expires', up.expires)
    formData.append('signature', up.signature)
    formData.append('file1', @file)

    xhr.open 'POST', up.url, true
    xhr.send formData
