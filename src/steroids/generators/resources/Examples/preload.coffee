steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Preload extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "preload"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "preloadExample.html"),
      path.join("app", "views", "preloadExample", "index.html"),
      path.join("app", "views", "preloadExample", "show.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "preloadExample")
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "preloadExample.html"), "layout.html.template"
    @addFile path.join("app", "views", "preloadExample", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "preloadExample", "show.html"), "show.html.template"

    Help.SUCCESS()
    console.log """

    Modal example generated successfully! The following files were created:
    
      - app/layouts/preloadExample.html
      - app/views/preloadExample/index.html
      - app/views/preloadExample/show.html
    
    To see the example in action, set the location of your app to:

      http://localhost/views/preloadExample/index.html

    """

module.exports = Preload
