steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class NavigationBar extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("examples", "navigationBar"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "navigationBarExample.html"),
      path.join("app", "views", "navigationBarExample", "index.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "navigationBarExample")
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "navigationBarExample.html"), "layout.html.template"
    @addFile path.join("app", "views", "navigationBarExample", "index.html"), "index.html.template"

    Help.SUCCESS()
    console.log """

    Modal example generated successfully! The following files were created:
    
      - app/layouts/navigationBarExample.html
      - app/views/navigationBarExample/index.html
    
    To see the example in action, set the location of your app to:

      http://localhost/views/navigationBarExample/index.html

    """

module.exports = NavigationBar
