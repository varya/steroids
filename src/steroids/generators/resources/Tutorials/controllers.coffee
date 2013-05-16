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
      path.join("app", "controllers", "tutorial.js")
      path.join("app", "views", "tutorial", "controllers.html")
      path.join("app", "views", "tutorial", "controllers-completed.html")
    ]

    @ensureDirectory path.join("app", "controllers")

    @copyFile path.join("app", "controllers", "application.js"), "application.js.template"
    @copyFile path.join("app", "controllers", "tutorial.js"), "tutorial.js.template"

    @ensureDirectory path.join("app", "views", "tutorial")

    @copyFile path.join("app", "views", "tutorial", "controllers.html"), "controllers.html.template"
    @copyFile path.join("app", "views", "tutorial", "controllers-completed.html"), "controllers-completed.html.template"


    Help.SUCCESS()

    console.log """

    Now change the first tab in config/application.coffee to point to

      http://localhost/views/tutorial/controllers.html

    Then reload the application.


    Bower, do your dance:

    """

module.exports = Controllers
