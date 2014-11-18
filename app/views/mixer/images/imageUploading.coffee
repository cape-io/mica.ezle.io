React = require 'react'
{div, span, img, strong, a} = require 'reactionary'

cdn = 'https://mica2015.imgix.net/'

module.exports = React.createClass
  getInitialState: ->
    progress: @props.model.progress
    src: @props.model.src

  componentDidMount: ->
    @props.model.on 'change:src', @handleSrcChange
    @props.model.on 'change:progress', @handleProgress

  componentWillUnmount: ->
    @props.model.off 'change:src', @handleSrcChange
    @props.model.off 'change:progress', @handleProgress

  handleProgress: (model, progress) ->
    if progress % 5 == 0
      @setState progress: progress

  handleSrcChange: (model, src) ->
    if src != @state.src
      @setState src: src

  render: ->
    div
      className: 'dz-preview dz-processing dz-image-preview col-md-2',
        div
          className: 'dz-details',
            # File name. Shown on hover with css.
            div
              className: 'dz-filename',
                span @props.model.fileName
            # The image file.
            img
              alt: @props.model.fileName
              src: @state.src
              width: '150'
            # Size of file. Shown below image.
            div
              className: 'dz-size',
                strong @props.model.humanSize.value
                span @props.model.humanSize.unit
        div
          className: 'dz-progress progress',
            div
              className: 'progress-bar'
              role: 'progressbar'
              style:
                width: @state.progress + '%'
              'aria-valuenow': @state.progress
              'aria-valuemin': '0'
              'aria-valuemax': '100',
                @state.progress + '%'
        a
          role: 'button'
          className: 'dz-remove',
            'Remove file'
