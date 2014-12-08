Model = require("ampersand-model")

module.exports = Model.extend
  idAttribute: 'id'
  url: ->
    app.api+'file/'+@id
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
    sortOrder:
      type: 'number'
      default: 100
    profilePic:
      type: 'boolean'
      default: false
    height:
      type: 'number'
    width:
      type: 'number'
  derived:
    sizeDisplay:
      deps: ['size']
      fn: ->
        str = @size
        if str == 'none'
          str = ''
        else if str == 'variable'
          'Variable'
        else if str
          size = str.replace('size-', '').split('x').map (unit) ->
            return unit+'in'
          if size[1]
            str = size[0] + ' x ' + size[1]
            if size[2]
              str += ' x '+size[2]
          else
            str = size[0]
        str
