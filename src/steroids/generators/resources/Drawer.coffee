steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class Drawer extends Base
  @usageParams: ->
    "<name>"

  @usage: ()->
    """
    Generates an example of Facebook style native drawer.

    Options:
      - name: name of the folder to create. Example: 'drawerExample' will result in the following files:
        - app/layouts/drawerExample.html
        - app/views/drawerExample/index.html
        - app/views/drawerExample/show.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "drawer")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "views", "#{@options.name}", "index.html"),
      path.join("app", "views", "#{@options.name}", "show.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", @options.name)
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "layout.html.template"
    @addFile path.join("app", "views", @options.name, "index.html"), "index.html.template"
    @addFile path.join("app", "views", @options.name, "show.html"), "show.html.template"

    Help.SUCCESS()
    console.log """

    Command completed successfully, now set the location of your app to:

      http://localhost/views/#{@options.name}/index.html

    """

module.exports = Drawer
