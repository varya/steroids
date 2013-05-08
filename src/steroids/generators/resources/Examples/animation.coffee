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
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "animationExample")
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "animationExample.html"), "layout.html.template"
    @addFile path.join("app", "views", "animationExample", "index.html"), "index.html.template"

    Help.SUCCESS()
    console.log """

    Animation example generated successfully! The following files were created:
    
      - app/layouts/animationExample.html
      - app/views/animationExample/index.html
    
    To see the example in action, set the location of your app to:

      http://localhost/views/animationExample/index.html

    """

module.exports = Animation
