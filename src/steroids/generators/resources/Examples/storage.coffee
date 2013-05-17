steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Storage extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "storage"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "storageExample.html"),
    ]

    @copyFile path.join("www", "storageExample.html"), "storageExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Storage example generated successfully! The following file was created:
    
      - www/storageExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      storageExample.html

    """

module.exports = Storage
