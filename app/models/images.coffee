Collection = require('ampersand-rest-collection')
Model = require('./image')
_ = require 'lodash'
module.exports = Collection.extend
  model: Model
  mainIndex: 'fileName'
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
        if 'profilePic' == key
          value = model['metadata'][key]
        else
          value = if model.get then model.get(key) else model[key]
        if value != val
          match = false
          return false
      return match
  # initialize: ->
  #   @on 'all', (a,b,c) ->
  #     console.log a,b,c
