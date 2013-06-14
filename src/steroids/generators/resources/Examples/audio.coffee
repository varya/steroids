steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Audio extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "audio"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "audioExample.html"),
      path.join("www", "sounds", "rockGuitar.mp3"),
    ]

    @ensureDirectory path.join("www")
    @ensureDirectory path.join("www", "sounds")

    @copyFile path.join("www", "audioExample.html"), "audioExample.html.template"
    @copyFile path.join("www", "sounds", "rockGuitar.mp3"), "rockGuitar.mp3"

    Help.SUCCESS()
    console.log """

    Cordova Audio example generated successfully! The following files were created:
    
      - www/audioExample.html
      - wwW/sounds/rockGuitar.mp3
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "audioExample.html"

    """

module.exports = Audio
