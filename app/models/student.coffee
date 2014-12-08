Model = require("ampersand-model")
crypto = require 'crypto'
_ = require 'lodash'

r = require 'superagent'
Cookies = require 'cookies-js'
data = require '../data/studentSchema'

Images = require './images'
Embeds = require './embeds'

props = data.props
props.uid.default = -> Cookies.get('uid')
props.picFileName = {type: 'string'}

module.exports = Model.extend
  idAttribute: 'uid'
  props: props
  fields: data.props
  session:
    tempToken: 'string'
    emailSent: ['boolean', false, false]
    loggedIn: ['boolean', true, false]
    token:
      type: 'string'
      default: -> Cookies.get('token')
      #ee731b86-033f-4c5c-b293-28f3892462d8d6d2eb15-8753-41d3-a0e8-3da8fa8b5aff
    tokenExpires: 'string'
    msgId: 'string'
    uploadInfo: 'object'
  collections:
    files: Images
    embeds: Embeds
  derived:
    email:
      deps: ['uid']
      fn: ->
        @emailFromUid(@uid)
    gravatar:
      deps: ['email']
      fn: ->
        @gravatarUrl(@email)

  initialize: ->
    @on 'change:tempToken', @logIn
    @on 'change:uid', (usr, uid) ->
      oldUid = Cookies.get 'uid'
      if uid != oldUid
        #console.log uid, 'set uid cookie'
        Cookies.set('uid', uid, expires: 15778463)
    # If we find a uid and token in the cookies log the user in.
    if @uid and @token and not @loggedIn
      #console.log 'This user has token and uid in a cookie.'
      @logIn()
    return

  emailFromUid: (uid) ->
    if uid == 'kai'
      'kai@ezle.io'
    else
      uid+'@mica.edu'

  gravatarUrl: (email) ->
    hash = crypto.createHash('md5').update(email).digest('hex')
    'https://www.gravatar.com/avatar/'+hash+'?d=retro&s=300'

  url: ->
    # If there is a tempToken, use it.
    if @tempToken
      app.api+'token/'+@uid+'/'+@tempToken
    else if @token
      # This will return sig needed for file uploads.
      app.api+'token/'+@uid+'/'+@token
    else
      app.api+'user/'+@uid

  parse: (usr) ->
    if usr.uid and not usr.pic
      usr.pic = @gravatarUrl(@emailFromUid(usr.uid))
    if usr.token and usr.tokenExpires
      Cookies.set('token', usr.token, expires: 15778463)
      usr.loggedIn = true
      usr.tempToken = null
    else
      Cookies.expire('token')
      Cookies.expire('uid')
    if usr.files and usr.files.length
      usr.files = _.map usr.files, (file) ->
        file.metadata.id = file.fileName
        file
    #console.log 'Parsed user.'
    return usr

  requestToken: (cb) ->
    if @uid
      console.log 'request'
      r.post app.api+'sendtoken', {email: @uid}, (err, res) =>
        if res.body.msgId
          @emailSent = true
          cb(true)
        else
          console.log res.body
          cb(false)
      return
    else
      console.log 'no email'

  logIn: ->
    unless @loggedIn
      #console.log 'Log this user in!'
      @fetch()

  logOut: ->
    Cookies.expire('token')
