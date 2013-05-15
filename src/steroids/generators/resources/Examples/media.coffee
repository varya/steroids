steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Media extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "media"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "mediaExample.html"),
    ]

    @copyFile path.join("www", "mediaExample.html"), "mediaExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Media example generated successfully! The following file was created:
    
      - www/mediaExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      mediaExample.html

    """

module.exports = Media
