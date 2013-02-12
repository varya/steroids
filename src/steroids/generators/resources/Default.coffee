steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

class Default extends Base
  @usageParams: ->
    "<resource>"

  @usage: ()->
    """
    Generates a stub resource consisting of a controller and a single index view.

    Options:
      - resource: name of resource to use. example: car will result in a carController and views/car/index.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "default")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.coffee"),
      path.join("app", "views", "#{@options.name}", "index.html")
    ]

    @addFile path.join("app", "controllers", "#{@options.name}.coffee"), "controller.coffee.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}")

    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"

    util.log "Command completed successfully."


module.exports = Default
