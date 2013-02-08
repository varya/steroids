steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"

Base = require "../Base"

class Angular extends Base
  @usageParams: ->
    "<scaffold>"

  @usage: ()->
    """
    Generates a scaffold build on top of angular.js. Includes a controller, a model and CRUD views.

    Options:
      - scaffold: name of scaffold to use
    """

  templatePath: ->
    path.join(steroids.paths.templates.scaffolds, "angular")

  generate: () ->
    @addFile path.join("app", "controllers", "#{@options.name}sController.coffee"), "controller.coffee.template"

    @ensureDirectory path.join("app", "models")

    @addFile path.join("app", "models", "#{@options.name}.coffee"), "model.coffee.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}s")

    @addFile path.join("app", "views", "#{@options.name}s", "index.html"), "index.html.template"

    @addFile path.join("app", "views", "#{@options.name}s", "show.html"), "show.html.template"

    @addFile path.join("app", "views", "#{@options.name}s", "bootstrap.html"), "bootstrap.html.template"


module.exports = Angular
