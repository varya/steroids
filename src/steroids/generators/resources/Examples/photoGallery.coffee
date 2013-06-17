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
      path.join("app", "views", "layouts", "photoGalleryExample.html"),
      path.join("app", "views", "photoGalleryExample", "index.html"),
      path.join("app", "views", "photoGalleryExample", "show.html")
      path.join("app", "controllers", "photoGalleryExample.js")
    ]
    
    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "photoGalleryExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")

    @copyFile path.join("app", "views", "photoGalleryExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "photoGalleryExample", "show.html"), "show.html.template"
    @copyFile path.join("app", "views", "layouts", "photoGalleryExample.html"), "layout.html.template"
    @copyFile path.join("app", "controllers", "photoGalleryExample.js"), "controller.js.template"

    Help.SUCCESS()
    console.log """

    Photo Gallery example generated successfully! The following files were created:
    
      - app/views/layouts/photoGalleryExample.html
      - app/views/photoGalleryExample/index.html
      - app/views/photoGalleryExample/show.html
      - app/controllers/photoGalleryExample.js
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      "http://localhost/views/photoGalleryExample/index.html"

    """

module.exports = PhotoGallery
