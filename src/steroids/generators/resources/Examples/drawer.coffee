steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"

class Drawer extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, "drawer")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "drawerExample.html"),
      path.join("app", "views", "drawerExample", "index.html"),
      path.join("app", "views", "drawerExample", "drawer.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "drawerExample")
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "drawerExample.html"), "layout.html.template"
    @addFile path.join("app", "views", "drawerExample", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "drawerExample", "drawer.html"), "drawer.html.template"

    Help.SUCCESS()
    console.log """

    Drawer example generated successfully! The following files were created:
    
      - app/layouts/drawerExample.html
      - app/views/drawerExample/index.html
      - app/views/drawerExample/drawer.html
    
    To see the example in action, set the location of your app to:

      http://localhost/views/drawerExample/index.html

    """

module.exports = Drawer
