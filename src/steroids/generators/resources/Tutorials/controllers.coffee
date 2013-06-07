steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"


class Controllers extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("tutorial", @options.name))

  generate: ->

    @checkForPreExistingFiles [
      path.join("app", "controllers", "application.js")
      path.join("app", "controllers", "steroidsTutorial.js")
      path.join("app", "views", "steroidsTutorial", "controllers.html")
      path.join("app", "views", "steroidsTutorial", "controllers-completed.html")
    ]

    unless fs.existsSync( path.join("app", "views", "layouts", "steroidsTutorial.html") )
      throw {
        fromSteroids: true
        message: "Could not find file app/views/layouts/steroidsTutorial.html. Please make sure you've generated the Steroids tutorial first with '$ steroids generate tutorial steroids'."
      }

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "controllers")

    @copyFile path.join("app", "controllers", "application.js"), "application.js.template"
    @copyFile path.join("app", "controllers", "steroidsTutorial.js"), "controller.js.template"

    @ensureDirectory path.join("app", "views", "steroidsTutorial")

    @copyFile path.join("app", "views", "steroidsTutorial", "controllers.html"), "controllers.html.template"
    @copyFile path.join("app", "views", "steroidsTutorial", "controllers-completed.html"), "controllers-completed.html.template"

    @addBowerDependency "jquery", "1.9.1"

    Help.SUCCESS()

    console.log """

    Now change the first tab in config/application.coffee to point to

      http://localhost/views/steroidsTutorial/controllers.html

    Then reload the application.


    Bower, do your dance:

    """

module.exports = Controllers
