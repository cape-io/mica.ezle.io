React = require 'react'
{h2, div, form, fieldset, p, a, img, button} = require 'reactionary'
{Navigation} = require 'react-router'

_ = require 'lodash'

data = require '../../../models/photo.yaml'
editableField = require '../editableField'

module.exports = React.createClass
  mixins: [Navigation]
  getInitialState: ->
    editField: null

  componentWillReceiveProps: (nextProps) ->
    @setState editField: null

  getFileName: ->
    app.me.uid+'/'+@props.params.splat

  getModel: ->
    model = app.me.files.get @getFileName()
    if model
      model.metadata
    else
      {}

  editField: (fieldId) ->
    @setState editField: fieldId

  handleFieldSubmit: (fieldId, value) ->
    console.log 'save field to metadata.'
    @getModel().save fieldId, value
    return

  handleDelete: (e) ->
    if e.preventDefault
      e.preventDefault()
    alert 'hi'
    fileName = @getFileName()
    console.log fileName
    #if confirm 'Are you sure you want to delete this image? It will be gone forever.'
    #  console.log 'confirmed'
      #app.me.files.get(fileName).destroy()
      #@transitionTo 'editImgs'
    return

  render: ->
    fileName = @getFileName()
    model = @getModel()

    fields = []
    _.forEach data.props, (field, fieldId) =>
      if field.label
        props = field
        props.key = fieldId
        props.id = fieldId
        props.value = model[fieldId]
        props.editField = @editField
        props.onSubmit = @handleFieldSubmit
        props.editing = @state.editField == fieldId
        fieldEl = editableField props
        fields.push fieldEl

    div
      className: 'row image-editor',
        div
          className: 'col-md-6 image-thumb',
            img
              src: 'https://mica2015.imgix.net/'+fileName+'?h=300'
        form
          className: 'form-horizontal col-md-6 image-meta',
            h2 'Image Details'
            fieldset {},
              fields
              div
                className: 'btn-group'
                role: 'group',
                  button
                    type: 'button'
                    onClick: =>
                      @transitionTo 'editImgs'
                    className: 'btn btn-primary',
                      'Done'
                  button
                    type: "button"
                    className: "btn btn-danger"
                    onClick: @handleDelete,
                      'Delete'
