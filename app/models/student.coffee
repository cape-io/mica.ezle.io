Model = require("ampersand-model")
r = require 'superagent'
Cookies = require 'cookies-js'
data = require '../data/studentSchema'

API = 'http://mica.ezle.io.ld:8000/'
#API = 'https://mica.ezle.io/'

props = data.props
props.uid.default = -> Cookies.get('uid')

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
    files: 'array'

  derived:
    email:
      deps: ['uid']
      fn: ->
        if @uid == 'kai'
          'kai@ezle.io'
        else
          @uid+'@mica.edu'

  initialize: ->
    @on 'change:tempToken', @logIn
    @on 'change:uid', (usr, uid) ->
      oldUid = Cookies.get 'uid'
      if uid != oldUid
        #console.log uid, 'set uid cookie'
        Cookies.set('uid', uid)
    # If we find a uid and token in the cookies log the user in.
    if @uid and @token and not @loggedIn
      #console.log 'This user has token and uid in a cookie.'
      @logIn()
    return

  url: ->
    # If there is a tempToken, use it.
    if @tempToken
      API+'token/'+@uid+'/'+@tempToken
    else if @token
      # This will return sig needed for file uploads.
      API+'token/'+@uid+'/'+@token
    else
      API+'user/'+@uid

  parse: (usr) ->
    # if usr.email
    #   usr.email = usr.email.split('@')[0]
    if usr.token and usr.tokenExpires
      Cookies.set('token', usr.token, expires: 15778463)
      usr.loggedIn = true
      usr.tempToken = null
    else
      Cookies.expire('token')
    #console.log 'Parsed user.'
    return usr

  requestToken: (cb) ->
    if @uid
      console.log 'request'
      r.post API+'sendtoken', {email: @uid}, (err, res) =>
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
