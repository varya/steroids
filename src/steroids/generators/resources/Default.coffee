steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class Default extends Base
  @usageParams: ->
    "<resource>"

  @usage: ()->
    """
    Generates a stub resource consisting of a controller and index show views.

    Options:
      - resource: name of resource to use. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "default")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.js"),
      path.join("app", "models", "#{@options.name}.js"),
      path.join("app", "views", "#{@options.name}", "index.html"),
      path.join("app", "views", "#{@options.name}", "show.html")
    ]

    @ensureDirectory path.join("app")

    @ensureDirectory path.join("app", "controllers")
    @addFile path.join("app", "controllers", "#{@options.name}.js"), "controller.js.template"

    @ensureDirectory path.join("app", "models")
    @addFile path.join("app", "models", "#{@options.name}.js"), "model.js.template"

    @ensureDirectory path.join("app", "views")

    @ensureDirectory path.join("app", "views", "layouts")
    @copyFile path.join("app", "views", "layouts", "application.html"), "layout.html.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}")
    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "show.html"), "show.html.template"

    @addBowerDependency "jquery", "1.9.1"

    Help.SUCCESS()
    console.log """

    Resource generated, set the location of your app to:

      http://localhost/views/#{@options.name}/index.html


    """


module.exports = Default
