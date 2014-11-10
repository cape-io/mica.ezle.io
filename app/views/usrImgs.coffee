React = require 'react'
crypto = require 'crypto'
{h1, div, fieldset, p, a, img} = require 'reactionary'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    gravImgs = []
    app.users.forEach (user) ->
      hash = crypto.createHash('md5').update(user.email).digest('hex')
      gravImgs.push img
        key: hash
        src: 'http://www.gravatar.com/avatar/'+hash+'?d=retro'
    div null,
      gravImgs
