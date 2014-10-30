Model = require("ampersand-model")
r = require 'superagent'
Cookies = require 'cookies-js'
data = require '../data/studentSchema'

props = data.props
props.email.default = -> Cookies.get('email')

module.exports = Model.extend
  idAttribute: 'email'
  props: props
  fields: data.props
  session:
    tempToken: 'string'
    emailSent: ['boolean', false, false]
    loggedIn: ['boolean', true, false]
    cookie:
      type: 'string'
      default: -> Cookies.get('token')
      #ee731b86-033f-4c5c-b293-28f3892462d8d6d2eb15-8753-41d3-a0e8-3da8fa8b5aff
    cookieExpires: 'string'
    msgId: 'string'
    uploadInfo: 'object'
    files: 'array'

  initialize: ->
    @on 'change:tempToken', @logIn
    @on 'change:email', (usr, email) ->
      oldEmail = Cookies.get 'email'
      if email != oldEmail
        console.log email, 'set email'
        Cookies.set('email', email)
    if @email and @cookie and not @loggedIn
      @logIn()
    return

  url: ->
    if @cookie and @email and not @loggedIn
      'https://mica.ezle.io/cookie/'+@email+'/'+@cookie
    else if @tempToken and @email and not @loggedIn
      # This will return sig needed for file uploads.
      'https://mica.ezle.io/token/'+@email+'/'+@tempToken
    else
      'https://mica.ezle.io/user/'+@email

  parse: (usr) ->
    if usr.email
      usr.email = usr.email.split('@')[0]
    if usr.cookie and usr.cookieExpires
      Cookies.set('token', usr.cookie, expires: 15778463)
      usr.loggedIn = true
    console.log 'Parsed user.'
    return usr

  requestToken: (cb) ->
    if @email
      console.log 'request'
      r.post 'https://mica.ezle.io/sendtoken', {email: @email}, (err, res) =>
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
      console.log 'Log this user in!'
      @fetch()
