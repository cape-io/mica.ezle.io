React = require 'react'
{html, head, title, meta, body, link, script} = require 'reactionary'

data = require '../data/data.json'

module.exports = React.createClass
  render: ->
    html null,
      head null,
        title data.title
        meta
          charSet: 'utf-8'
        link
          rel: 'stylesheet'
          type: 'text/css'
          media: 'print'
          href: '/print.css'
        link
          rel: 'stylesheet'
          type: 'text/css'
          href: '/app.css'
      body null,
        div
          id: 'react',
            h1 #{title}
        script
          type: 'text/javascript'
          src: 'app.js'
