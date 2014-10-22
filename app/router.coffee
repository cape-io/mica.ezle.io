Qs = require 'qs'
_ = require 'lodash'
Router = require 'ampersand-router'

module.exports = Router.extend

  routes:
    '': 'login'
    'form': 'form'
    'form/imgs': 'imgs'
    'login': 'login'
    'img': 'img'

  form: ->
    @setReactState section: 'form'

  imgs: ->
    @setReactState section: 'imgs'

  login: ->
    @setReactState section: 'login'

  img: ->
    @setReactState section: 'img'
