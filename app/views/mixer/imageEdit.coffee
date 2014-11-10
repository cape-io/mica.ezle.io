React = require 'react'
{h2, div, form, fieldset, p, a, img} = require 'reactionary'
_ = require 'lodash'

data = require '../../models/photo.yaml'
editableField = require './editableField'

module.exports = React.createClass
  getInitialState: ->
    editField: null

  editField: (fieldId) ->
    @setState editField: fieldId

  render: ->
    fileName = @props.params.splat

    fields = []
    _.forEach data.props, (field, fieldId) =>
      if field.label
        props = field
        props.key = fieldId
        props.id = fieldId
        #props.value = user[fieldId]
        props.editField = @editField
        props.editing = @state.editField == fieldId
        fieldEl = editableField props
        fields.push fieldEl

    div
      className: 'row',
        div
          className: 'col-md-6',
            img
              src: 'https://mica2015.imgix.net/'+app.me.uid+'/'+fileName+'?h=300'
        form
          className: 'form-horizontal col-md-6',
            h2 'Image Details'
            fieldset {},
              fields
