Qs = require 'qs'
_ = require 'lodash'
Router = require 'ampersand-router'

module.exports = Router.extend

  routes:
    '': 'form'
    'form': 'form'

  form: ->
    console.log 'form'
    @setReactState section: 'form'
