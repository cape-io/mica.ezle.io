React = require 'react'
{li, a, img} = require 'reactionary'

cdn = 'https://mica2015.imgix.net/'

module.exports = React.createClass
  # getInitialState: ->

  render: ->
    model = @props.model
    li
      className: 'col-md-2',
        a
          href: model.editUrl,
            img
              className: 'img-thumbnail'
              src: model.thumbSrc
              alt: model.md5
