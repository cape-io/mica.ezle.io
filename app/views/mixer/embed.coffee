React = require 'react'
{h1, div, fieldset, p, a, form, button} = require 'reactionary'
_ = require 'lodash'
editableField = require './editableField'

module.exports = React.createClass
  getInitialState: ->
    editField: null
    newField: false

  addField: (e) ->
    e.preventDefault()
    if app.me.embeds.length < 20
      nextId = parseInt(_.last(app.me.embeds.pluck('id')))+1
      console.log nextId
      @setState
        newField: true
        editField: nextId+''

  editField: (fieldId) ->
    @setState editField: fieldId

  getModel: (fieldId) ->
    app.me.embeds.get(fieldId)

  handleFieldSubmit: (fieldId, value) ->
    #fieldId = (fieldId+1)+''
    model = @getModel(fieldId)
    if model
      console.log 'Save field to metadata.', fieldId, value
      if value
        model.set 'uri', value
      else
        app.me.embeds.remove(model)
        app.me.save()
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

  embedField: (model) ->
#    fieldId = (fieldId+1)+''
#    model = @getModel fieldId
    fieldId = model.id
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
    embeds = app.me.embeds.map @embedField
    if @state.newField and @state.editField
      embeds.push @embedField({id: @state.editField})
    form
      className: 'form-horizontal col-md-6',
        embeds
        button
          onClick: @addField,
            '+ More'
