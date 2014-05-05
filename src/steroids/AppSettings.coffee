paths = require "./paths"
Converter = require "./Converter"
fs = require "fs"

class AppSettings

  constructor: ->

  getJSON: ->
    converter = new Converter

    settingsObject = converter.configToAnkaFormat()

    JSON.stringify settingsObject

  createJSONFile: ->
    settingsAsJson = @getJSON()
    fs.writeFileSync paths.application.configs.appgyverSettings, settingsAsJson

module.exports = AppSettings
