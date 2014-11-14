React = require 'react'
{html, head, title, meta, body, link, script, h1, div, header} = require 'reactionary'

data = require '../data/data.json'

module.exports = React.createClass
  render: ->
    appFileName = @props.sha or 'app'
    html null,
      head null,
        title data.title
        meta
          charSet: 'utf-8'
        link
          rel: 'stylesheet'
          type: 'text/css'
          href: '//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css'
        link
          rel: 'stylesheet'
          type: 'text/css'
          media: 'print'
          href: '/print.css'
        link
          rel: 'stylesheet'
          type: 'text/css'
          href: '/#{appFileName}.css'
      body null,
        div
          id: 'react',
            header
              h1 data.title
        script
          type: 'text/javascript'
          src: "/#{appFileName}.js"
