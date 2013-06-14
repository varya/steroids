steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Accelerometer extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "accelerometer"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "accelerometerExample.html"),
    ]

    @copyFile path.join("www", "accelerometerExample.html"), "accelerometerExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Accelerometer example generated successfully! The following file was created:

      - www/accelerometerExample.html

    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "accelerometerExample.html"

    """

module.exports = Accelerometer
