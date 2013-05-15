steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Compass extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "compass"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "compassExample.html"),
    ]

    @copyFile path.join("www", "compassExample.html"), "compassExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Compass example generated successfully! The following file was created:
    
      - www/compassExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      compassExample.html

    """

module.exports = Compass
