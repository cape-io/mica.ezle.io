Model = require("ampersand-model")

module.exports = Model.extend
  idAttribute: 'id'
  props:
    id: 'string'
    title:
      type: 'string'
    size:
      type: 'string'
    medium:
      type: 'string'
    year:
      type: 'string'
    description:
      type: 'string'

  url: ->
    app.api+'file/'+@id
