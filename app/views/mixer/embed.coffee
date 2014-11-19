React = require 'react'
{h1, div, fieldset, p, a, form, button} = require 'reactionary'
_ = require 'lodash'
editableField = require './editableField'

module.exports = React.createClass
  getInitialState: ->
    fieldQty: 1
    editField: null

  addField: (e) ->
    e.preventDefault()
    if @state.fieldQty < 20
      @setState fieldQty: @state.fieldQty + 1

  editField: (fieldId) ->
    @setState editField: fieldId

  getModel: (fieldId) ->
    app.me.embeds.get(fieldId)

  handleFieldSubmit: (fieldId, value) ->
    #fieldId = (fieldId+1)+''
    model = @getModel(fieldId)
    if model
      console.log 'Save field to metadata.', fieldId, value
      model.set 'uri', value
    else
      console.log 'Create embed model.', fieldId, value
      app.me.embeds.add
        id: fieldId
        uri: value
      app.me.save()
    return

  componentDidMount: ->
    app.me.embeds.on 'change:oembed', @handleOembedUpdate

  componentWillUnmount: ->
    app.me.embeds.off 'change:oembed', @handleOembedUpdate

  handleOembedUpdate: ->
    console.log 'updated'
    @forceUpdate()

  embedField: (fieldId) ->
    fieldId = (fieldId+1)+''
    model = @getModel fieldId
    props =
      help: 'Paste in a URL from a website like youtube, vimeo, soundcloud etc.'
      label: 'Media Link'
      element: 'text'
    props.key = fieldId
    props.id = fieldId

    props.editField = @editField
    props.onSubmit = @handleFieldSubmit
    props.editing = @state.editField == fieldId

    if model and model.uri
      props.value = model and model.uri
      if model.oembed and model.oembed.html
        preview = div
          className: 'oembed oembed-iframe'
          key: fieldId+'preview'
          dangerouslySetInnerHTML:
            __html: model.oembed.html
      else
        preview = div
          key: fieldId+'preview'
          className: 'oembed oembed-loading'
          dangerouslySetInnerHTML:
            __html: "<p>Loading</p>"
            #p 'loading'
    else
      preview = false
    div
      key: fieldId
      className: 'embed-field',
        editableField props
        preview

  render: ->
    fieldQty = @state.fieldQty
    embeds = _.map _.range(fieldQty), @embedField

    form
      className: 'form-horizontal col-md-6',
        embeds
        button
          onClick: @addField,
            '+ More'
