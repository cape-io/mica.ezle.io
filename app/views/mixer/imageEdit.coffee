React = require 'react'
{h2, div, form, fieldset, p, a, img, button} = require 'reactionary'
{Navigation} = require 'react-router'

_ = require 'lodash'

data = require '../../models/photo.yaml'
editableField = require './editableField'

module.exports = React.createClass
  mixins: [Navigation]
  getInitialState: ->
    editField: null

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

  handleDelete: () ->
    fileName = @getFileName()
    if confirm 'Are you sure you want to delete this image? It will be gone forever.'
      app.me.files.get(fileName).destroy()
      @transitionTo 'editImgs'

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
      className: 'row',
        div
          className: 'col-md-6',
            img
              src: 'https://mica2015.imgix.net/'+fileName+'?h=300'
        form
          className: 'form-horizontal col-md-6',
            h2 'Image Details'
            fieldset {},
              fields
              button
                type: "button"
                className: "btn btn-danger"
                onClick: @handleDelete,
                  'Delete'
