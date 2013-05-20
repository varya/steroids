steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class PhotoGallery extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "photoGallery"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "views", "layouts", "galleryExample.html"),
      path.join("app", "views", "galleryExample", "index.html"),
      path.join("app", "views", "galleryExample", "show.html")
      path.join("app", "controllers", "galleryExample.js")
    ]
    
    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "galleryExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")

    @copyFile path.join("app", "views", "galleryExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "galleryExample", "show.html"), "show.html.template"
    @copyFile path.join("app", "views", "layouts", "galleryExample.html"), "layout.html.template"
    @copyFile path.join("app", "controllers", "galleryExample.js"), "controller.js.template"

    Help.SUCCESS()
    console.log """

    Cordova Photo Gallery example generated successfully! The following files were created:
    
      - app/views/galleryExample/index.html
      - app/views/galleryExample/show.html
      - app/views/layouts/galleryExample.html
      - app/controllers/galleryExample.js
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      http://localhost/views/galleryExample/index.html

    """

module.exports = PhotoGallery
