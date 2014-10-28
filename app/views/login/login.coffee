React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'
{Navigation} = require 'react-router'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

validUsers = require '../../models/users'

# validUsers.forEach (id) ->
#   validUsers.forEach (usr) ->
#     if id != usr and _.contains usr, id
#       console.log usr, id

module.exports = React.createClass
  mixins: [Navigation]
  getInitialState: ->
    email: ''
    checkEmail: false

  handleLogin: (usr, loggedIn) ->
    if loggedIn
      @transitionTo 'mixer'
  statics:
    willTransitionTo: (transition) ->
      console.log 'transition'
      if app.me.loggedIn
        transition.redirect('mixer')

  componentWillMount: ->
    app.me.on 'change:loggedIn', @handleLogin
    return

  componentWillUnmount: ->
    console.log 'unmount'
    app.me.off 'change:loggedIn', @handleLogin

  handleSubmit: (email) ->
    app.me.email = email
    app.me.requestToken (res) =>
      if res
        @transitionTo('checkEmail')
      else
        @transitionTo('loginFail')
      return
    @transitionTo('emailPending')

  changeEmail: ->
    email = @refs.email.getValue()
    if _.contains email, '@'
      email = email.split('@')[0]
    if _.contains email, '.'
      email = email.split('.')[0]
    email = email.replace 'mica', ''
    email = email.replace 'edu', ''
    # Validate email.
    if _.contains validUsers, email
      @handleSubmit(email)
    else if email is ''
      @setState
        emailStatus: null
        email: email
    else
      @setState
        emailStatus: 'error'
        email: email

  render: ->
    fieldset null,
      Input
        type: 'text'
        value: @state.email
        placeholder: 'Enter MICA email'
        label: 'Your MICA email please'
        help: 'No need to include @mica.edu (e.g. if your email is kbjornard@mica.edu, you would just enter kbjornard)'
        bsStyle: @state.emailStatus
        ref: 'email'
        hasFeedback: true
        groupClassName: 'group-class-customize-me'
        wrapperClassName: 'wrapper-class-customize-me'
        labelClassName: 'label-class-editable'
        onChange: @changeEmail
        addonAfter: '@mica.edu'
      # Input
      #   type: 'submit'
      #   onClick: @handleSubmit
