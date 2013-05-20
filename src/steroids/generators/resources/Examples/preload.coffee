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
      path.join("app", "views", "preloadExample", "show.html"),
      path.join("app", "controllers", "preloadExample.js")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "preloadExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")
    

    @copyFile path.join("app", "views", "layouts", "preloadExample.html"), "layout.html.template"
    @copyFile path.join("app", "views", "preloadExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "preloadExample", "show.html"), "show.html.template"
    @copyFile path.join("app", "controllers", "preloadExample.js"), "controller.js.template"

    Help.SUCCESS()
    console.log """

    Modal example generated successfully! The following files were created:
    
      - app/layouts/preloadExample.html
      - app/views/preloadExample/index.html
      - app/views/preloadExample/show.html
      - app/controllers/preloadExample.js
      
    
    To see the example in action, set the location of your app to:

      http://localhost/views/preloadExample/index.html

    """

module.exports = Preload
