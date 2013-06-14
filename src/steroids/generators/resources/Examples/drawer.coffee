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
    path.join(steroids.paths.templates.resources, path.join("examples", "drawer"))

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "drawerExample.html"),
      path.join("app", "views", "drawerExample", "index.html"),
      path.join("app", "views", "drawerExample", "index.android.html"),
      path.join("app", "views", "drawerExample", "drawer.html"),
      path.join("app", "controllers", "drawerExample.js")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", "drawerExample")
    @ensureDirectory path.join("app", "views", "layouts")
    @ensureDirectory path.join("app", "controllers")

    @copyFile path.join("app", "views", "layouts", "drawerExample.html"), "layout.html.template"
    @copyFile path.join("app", "views", "drawerExample", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "drawerExample", "index.android.html"), "index.android.html.template"
    @copyFile path.join("app", "views", "drawerExample", "drawer.html"), "drawer.html.template"
    @copyFile path.join("app", "controllers", "drawerExample.js"), "controller.js.template"

    Help.SUCCESS()
    console.log """

    Drawer example generated successfully! The following files were created:
    
      - app/views/layouts/drawerExample.html
      - app/views/drawerExample/index.html
      - app/views/drawerExample/index.android.html
      - app/views/drawerExample/drawer.html
      - app/controllers/drawerExample.js
    
    To see the example in action, set the steroids.config.location property in
    config/application.coffee to:

      http://localhost/views/drawerExample/index.html

    """

module.exports = Drawer
