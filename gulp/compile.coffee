fs = require 'fs'
react = require 'react'
PublicIndex = require '../app/views/public/index'
AdminIndex = require '../app/views/admin/index'

html = react.renderComponentToStaticMarkup PublicIndex(null)
fs.writeFile('public/index.html', html)

html = react.renderComponentToStaticMarkup AdminIndex(null)
fs.writeFile('public/admin.html', html)
