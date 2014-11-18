Collection = require('ampersand-rest-collection')
Model = require('./image')
_ = require 'lodash'
module.exports = Collection.extend
  model: Model
  mainIndex: 'fileName'
  url: 'http://mica.cape.io.ld:8000/project/t/files.json'
  comparator: (model) ->
    model.metadata.sortOrder

  where: (attrs) ->
    if _.isEmpty attrs
      return []
    # Check each model.
    _.filter @models, (model) ->
      # Check for each value one at a time.
      match = true
      _.each attrs, (val, key) ->
        value = if model.get then model.get(key) else model[key]
        if value != val
          match = false
          return false
      return match
  # initialize: ->
  #   @on 'all', (a,b,c) ->
  #     console.log a,b,c
