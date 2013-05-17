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
      path.join("www", "galleryExampleIndex.html"),
      path.join("www", "galleryExampleShow.html"),
      path.join("www", "javascripts", "gallery.js")
    ]

    @copyFile path.join("www", "galleryExampleIndex.html"), "galleryExampleIndex.html.template"
    @copyFile path.join("www", "galleryExampleShow.html"), "galleryExampleShow.html.template"
    @copyFile path.join("www", "javascripts", "gallery.js"), "gallery.js.template"

    Help.SUCCESS()
    console.log """

    Cordova Photo Gallery example generated successfully! The following files were created:
    
      - www/galleryExampleIndex.html
      - www/galleryExampleShow.html
      - www/javascripts/gallery.js
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      galleryExampleIndex.html

    """

module.exports = PhotoGallery
