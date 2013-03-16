steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

class Angular extends Base
  @usageParams: ->
    "<resource>"

  @usage: ()->
    """
    Generates a stub angular resource consisting of a controller, index view and show view.

    Options:
      - resource: name of resource to use. example: car will result in a app/controllers/car.js, views/car/index.html and views/car/show.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "angular")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.js"),
      path.join("app", "views", "#{@options.name}", "index.html")
      path.join("app", "views", "#{@options.name}", "show.html")
    ]

    @addFile path.join("app", "controllers", "#{@options.name}.js"), "controller.js.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}")

    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_list.html"), "list.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_details.html"), "details.html.template"

    @addBowerDependency "angular", "1.0.4"

    console.log ""
    console.log "NOTICE: Add the following line to your application layout <head> element if not already present:"
    console.log ""
    console.log "<script src=\"/components/angular/angular.min.js\"></script>"
    console.log ""

    util.log "Command completed successfully."


module.exports = Angular
