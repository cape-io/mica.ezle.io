Collection = require('ampersand-rest-collection')
Model = require('./embed')

module.exports = Collection.extend
  model: Model
  # url: ->
  #   @parent.url()
  # sync: ->
  #   sync.apply {embeds: @}, arguments
