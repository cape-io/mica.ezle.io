Model = require("ampersand-model")
r = require 'superagent'
module.exports = Model.extend

  props:
    id: 'string'
    uri:
      type: 'string'
  session:
    oembed:
      type: 'object'

  initialize: ->
    @on 'add', @getOembed
    return

  getOembed: ->
    console.log 'grab oembed info for '+@uri
    r.get 'http://api.embed.ly/1/oembed?url='+@uri, (err, res) =>
      if res and not err
        @oembed = res.body
        @trigger 'change:oembed', @, res.body
