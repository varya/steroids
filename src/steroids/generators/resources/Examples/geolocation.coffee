steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Geolocation extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "geolocation"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "geolocationExample.html"),
    ]

    @copyFile path.join("www", "geolocationExample.html"), "geolocationExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Geolocation example generated successfully! The following file was created:
    
      - www/geolocationExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "geolocationExample.html"

    """

module.exports = Geolocation
