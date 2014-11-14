fs = require 'fs'
react = require 'react'
PublicIndex = require '../app/views/index'

html = react.renderComponentToStaticMarkup PublicIndex(null)
fs.writeFile('dev/index.html', html)
