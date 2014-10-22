Collection = require('ampersand-rest-collection')
Model = require('./image')

module.exports = Collection.extend
  model: Model
  mainIndex: 'fileName'
  # initialize: ->
  #   @on 'all', (a,b,c) ->
  #     console.log a,b,c
