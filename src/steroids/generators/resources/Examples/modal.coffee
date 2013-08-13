steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"
wrench = require "wrench"

Base = require "../../Base"
Help = require "../../../Help"

class Modal extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "modal"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "modalExample.html"),
      path.join("app", "views", "modalExample", "index.html"),
      path.join("app", "views", "modalExample", "show.html"),
      path.join("app", "controllers", "modalExample.js")
      path.join("tests", "examples", "modalSpec.js")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "modalExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")
    @ensureDirectory path.join("tests")
    @ensureDirectory path.join("tests", "examples")

    @copyFile path.join("app", "views", "layouts", "modalExample.html"), "layout.html.template"
    @copyFile path.join("app", "views", "modalExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "modalExample", "show.html"), "show.html.template"
    @copyFile path.join("app", "controllers", "modalExample.js"), "controller.js.template"
    @copyFile path.join("tests", "examples", "modalSpec.js"), "test.js.template"

    unless path.existsSync(path.join @applicationPath, "tests", "tuneup_js")
      wrench.copyDirSyncRecursive paths.templates.tuneupJS, path.join(@applicationPath, "tests", "tuneup_js")

    Help.SUCCESS()
    console.log """

    Modal example generated successfully! The following files were created:

      - app/views/layouts/modalExample.html
      - app/views/modalExample/index.html
      - app/views/modalExample/show.html
      - app/controllers/modalExample.js
      - tests/examples/modalSpec.js

    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "http://localhost/views/modalExample/index.html"

    """


module.exports = Modal
