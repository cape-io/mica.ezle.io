React = require 'react/addons'
cx = React.addons.classSet
{li, a, img} = require 'reactionary'
{Sortable} = require '../../../react-sortable'

cdn = 'https://mica2015.imgix.net/'

module.exports = React.createClass
  # getInitialState: ->
  mixins: [Sortable]
  render: ->
    liClasses = cx
      'col-md-2': true
      'dragable': true
      'dragging': @isDragging()

    model = @props.model
    li
      className: liClasses,
        a
          href: model.editUrl,
            img
              className: 'img-thumbnail'
              src: model.thumbSrc
              alt: model.md5
              width: '150'
              height: '150'
