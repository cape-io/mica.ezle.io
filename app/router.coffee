Qs = require 'qs'
_ = require 'lodash'
Router = require 'ampersand-router'

module.exports = Router.extend

  routes:
    '': 'form'
    'form': 'form'
    'login': 'login'

  form: ->
    @setReactState section: 'form'

  login: ->
    @setReactState section: 'login'
