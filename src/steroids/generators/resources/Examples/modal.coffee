steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Modal extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, "modal")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "modalExample.html"),
      path.join("app", "views", "modalExample", "index.html"),
      path.join("app", "views", "modalExample", "show.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "modalExample")
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "modalExample.html"), "layout.html.template"
    @addFile path.join("app", "views", "modalExample", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "modalExample", "show.html"), "show.html.template"

    Help.SUCCESS()
    console.log """

    Modal example generated successfully! The following files were created:
    
      - app/layouts/modalExample.html
      - app/views/modalExample/index.html
      - app/views/modalExample/show.html
    
    To see the example in action, set the location of your app to:

      http://localhost/views/modalExample/index.html

    """


module.exports = Modal
