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
    Generates an angular scaffold consisting of a controller, a model and index, show, new and edit views.

    The scaffold model can use any JSON REST API as backend that plays well with angular.

    Options:
      - resource: name of resource to use. example: car will result in a CarController, a Car model and views/car/*.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.scaffolds, "angular")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.coffee")
      path.join("app", "models", "#{@options.name}.coffee")
      path.join("app", "views", "#{@options.name}", "index.html")
      path.join("app", "views", "#{@options.name}", "list.html")
      path.join("app", "views", "#{@options.name}", "details.html")
    ]

    @addFile path.join("app", "controllers", "#{@options.name}.coffee"), "controller.coffee.template"

    @ensureDirectory path.join("app", "models")
    @addFile path.join("app", "models", "#{@options.name}.coffee"), "model.coffee.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}")

    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_list.html"), "list.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_details.html"), "details.html.template"

    @addBowerDependency "angular", "1.0.4"
    @addBowerDependency "angular-resource", "1.0.4"

    console.log ""
    console.log "NOTICE: Add the following lines to your application layout <head> element:"
    console.log ""
    console.log "<script src=\"/components/angular/angular.min.js\"></script>"
    console.log "<script src=\"/components/angular-resource/angular-resource.min.js\"></script>"
    console.log ""

    util.log "Command completed successfully."


module.exports = Angular
