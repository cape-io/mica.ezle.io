Qs = require 'qs'
_ = require 'lodash'
Router = require 'ampersand-router'

module.exports = Router.extend

  routes:
    '': 'form'
    'form': 'form'
    'form/imgs': 'imgs'
    'login': 'login'

  form: ->
    @setReactState section: 'form'

  imgs: ->
    @setReactState section: 'imgs'

  login: ->
    @setReactState section: 'login'
