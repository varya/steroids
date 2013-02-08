steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"

Base = require "../Base"

class Default extends Base
  @usageParams: ->
    "<resource>"

  @usage: ()->
    """
    Generates a stub resource consisting of a controller and a single index view.

    Options:
      - resource: name of resource to use
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "default")

  generate: ->
    @addFile path.join("app", "controllers", "#{@options.name}sController.coffee"), "controller.coffee.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}s")

    @addFile path.join("app", "views", "#{@options.name}s", "index.html"), "index.html.template"


module.exports = Default
