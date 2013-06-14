steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class DrumMachine extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "drumMachine"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "drumMachineExample.html"),
      path.join("app", "views", "drumMachineExample", "index.html"),
      path.join("app", "controllers", "drumMachineExample.js"),
      path.join("www", "sounds", "drumMachineExample", "clap.wav"),
      path.join("www", "sounds", "drumMachineExample", "hihat.wav"),
      path.join("www", "sounds", "drumMachineExample", "kick.wav"),
      path.join("www", "sounds", "drumMachineExample", "perc.wav"),
      path.join("www", "sounds", "drumMachineExample", "perc2.wav"),
      path.join("www", "sounds", "drumMachineExample", "snare.wav")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "drumMachineExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")
    @ensureDirectory path.join("www")
    @ensureDirectory path.join("www", "sounds")
    @ensureDirectory path.join("www", "sounds", "drumMachineExample")

    @copyFile path.join("app", "views", "layouts", "drumMachineExample.html"), "layout.html.template"
    @copyFile path.join("app", "views", "drumMachineExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "controllers", "drumMachineExample.js"), "controller.js.template"
    @copyFile path.join("www", "sounds", "drumMachineExample", "clap.wav"), "clap.wav"
    @copyFile path.join("www", "sounds", "drumMachineExample", "hihat.wav"), "hihat.wav"
    @copyFile path.join("www", "sounds", "drumMachineExample", "kick.wav"), "kick.wav"
    @copyFile path.join("www", "sounds", "drumMachineExample", "perc.wav"), "perc.wav"
    @copyFile path.join("www", "sounds", "drumMachineExample", "perc2.wav"), "perc2.wav"
    @copyFile path.join("www", "sounds", "drumMachineExample", "snare.wav"), "snare.wav"

    Help.SUCCESS()
    console.log """

    Drawer example generated successfully! The following files were created:
    
      - app/views/layouts/drumMachineExample.html
      - app/views/drumMachineExample/index.html
      - app/controllers/drumMachineExample.js
      - www/sounds/drumMachineExample/clap.wav
      - www/sounds/drumMachineExample/hihat.wav
      - www/sounds/drumMachineExample/kick.wav
      - www/sounds/drumMachineExample/perc.wav
      - www/sounds/drumMachineExample/perc2.wav
      - www/sounds/drumMachineExample/snare.wav
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "http://localhost/views/drumMachineExample/index.html"

    """

module.exports = DrumMachine
