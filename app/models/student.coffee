Model = require("ampersand-model")
r = require 'superagent'

data = require './student.yaml'

module.exports = Model.extend
  idAttribute: 'email'
  props: data.props
  fields: data.props
  session:
    emailSent: ['boolean', false, false]

  url: ->
    'https://mica.ezle.io/user/'+@email+'.json'

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
