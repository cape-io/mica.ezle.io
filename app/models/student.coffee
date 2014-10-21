Model = require("ampersand-model")

data = require './student.yaml'

module.exports = Model.extend
  props: data.props
  fields: data.props
  url: ->
    'http://mfa.cape.io/student/'+@id+'.json'
