React = require 'react'
{h1, div, fieldset, p, a} = require 'reactionary'
Input = require 'react-bootstrap/Input'
_ = require 'lodash'

validUsers = require '../models/users'

# validUsers.forEach (id) ->
#   validUsers.forEach (usr) ->
#     if id != usr and _.contains usr, id
#       console.log usr, id

module.exports = React.createClass
  getInitialState: ->
    email: ''
    checkEmail: false

  handleSubmit: (email) ->
    app.me.email = email
    app.me.requestToken (res) =>
      if res
        @setState checkEmail: true
      return

  validationState: ->
    email = @state.email
    unless email then return
    if _.contains validUsers, email
      @handleSubmit(email)
      'success'
    else
      'error'

  changeEmail: ->
    email = @refs.email.getValue()
    if _.contains email, '@'
      email = email.split('@')[0]
    if _.contains email, '.'
      email = email.split('.')[0]
    email = email.replace 'mica', ''
    email = email.replace 'edu', ''
    @setState email: email

  render: ->
    fieldset null,
      Input
        type: 'text'
        value: @state.email
        placeholder: 'Enter MICA email'
        label: 'Your MICA email please'
        help: 'No need to include @mica.edu (e.g. if your email is kbjornard@mica.edu, you would just enter kbjornard)'
        bsStyle: @validationState()
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
