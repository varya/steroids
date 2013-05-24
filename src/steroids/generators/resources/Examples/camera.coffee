steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Camera extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "camera"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "cameraExample.html"),
      path.join("www", "images", "spinner.gif")
    ]
    
    @ensureDirectory path.join("www", "images")

    @copyFile path.join("www", "cameraExample.html"), "cameraExample.html.template"
    @copyFile path.join("www", "images", "spinner.gif"), "spinner.gif"

    Help.SUCCESS()
    console.log """

    Cordova Camera example generated successfully! The following files were created:
    
      - www/cameraExample.html
      - www/images/spinner.gif
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      cameraExample.html

    """

module.exports = Camera
