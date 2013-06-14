steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Device extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "device"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "deviceExample.html"),
    ]

    @copyFile path.join("www", "deviceExample.html"), "deviceExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Device Properties example generated successfully! The following file was created:
    
      - www/deviceExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "deviceExample.html"

    """

module.exports = Device
