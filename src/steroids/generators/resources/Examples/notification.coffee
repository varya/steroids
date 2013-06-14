steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Notification extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "notification"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("www", "notificationExample.html"),
    ]

    @copyFile path.join("www", "notificationExample.html"), "notificationExample.html.template"

    Help.SUCCESS()
    console.log """

    Cordova Notification example generated successfully! The following file was created:
    
      - www/notificationExample.html
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "notificationExample.html"

    """

module.exports = Notification
