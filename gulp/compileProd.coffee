fs = require 'fs'
react = require 'react'
PublicIndex = require '../app/views/index'
commit = require '../app/data/commit.json'

html = react.renderComponentToStaticMarkup PublicIndex(sha: commit.sha)
fs.writeFile('prod/index.html', html)
