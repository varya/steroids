steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Animation extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "animation"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "animationExample.html"),
      path.join("app", "views", "animationExample", "index.html"),
      path.join("app", "views", "animationExample", "index.android.html"),
      path.join("app", "controllers", "animationExample.js")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "animationExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")
    

    @copyFile path.join("app", "views", "layouts", "animationExample.html"), "layout.html.template"
    @copyFile path.join("app", "views", "animationExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "animationExample", "index.android.html"), "index.android.html.template"
    @copyFile path.join("app", "controllers", "animationExample.js"), "controller.js.template"

    Help.SUCCESS()
    console.log """

    Animation example generated successfully! The following files were created:
    
      - app/views/layouts/animationExample.html
      - app/views/animationExample/index.html
      - app/views/animationExample/index.android.html
      - app/controllers/animationExample.js
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "http://localhost/views/animationExample/index.html"

    """

module.exports = Animation
