Collection = require('ampersand-rest-collection')
Model = require('./image')

module.exports = Collection.extend
  model: Model
  mainIndex: 'fileName'
  url: 'http://mica.cape.io.ld:8000/project/t/files.json'
  # initialize: ->
  #   @on 'all', (a,b,c) ->
  #     console.log a,b,c
