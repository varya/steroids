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

  constructor: (@options)->
    super(@options)

    @templatePath = path.join(steroids.paths.templates.resources, "default")

  generate: ->
    @addFile path.join(@applicationPath, "app", "controllers", "#{@options.name}sController.coffee"),
      @renderTemplate(path.join(@templatePath, "controller.coffee.template"))

    @ensureDirectory path.join(@applicationPath, "app", "views", "#{@options.name}s")

    @addFile path.join(@applicationPath, "app", "views", "#{@options.name}s", "index.html"),
      @renderTemplate(path.join(@templatePath, "index.html.template"))


module.exports = Default
