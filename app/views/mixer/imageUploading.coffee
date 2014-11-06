React = require 'react'
{div, span, img, strong, a} = require 'reactionary'

cdn = 'https://mica2015.imgix.net/'

module.exports = React.createClass
  getInitialState: ->
    progress: @props.model.progress

  componentDidMount: ->
    # app.images.on 'change:src', =>
    #   @forceUpdate()
    app.images.on 'change:progress', @handleProgress

  componentWillUnmount: ->
    app.images.off 'change:progress', @handleProgress

  handleProgress: (model, progress) ->
    if progress % 5 == 0
      @setState progress: progress

  render: ->
    console.log @props.model.fileName
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
              src: @props.model.src
              width: '170'
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
