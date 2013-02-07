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

  constructor: (@options)->
    super(@options)

    @templatePath = path.join(steroids.paths.templates.scaffolds, "angular")

  generate: () ->
    @addFile path.join(@applicationPath, "app", "controllers", "#{@options.name}sController.coffee"),
      @renderTemplate(path.join(@templatePath, "controller.coffee.template"))

    @ensureDirectory path.join(@applicationPath, "app", "models")

    @addFile path.join(@applicationPath, "app", "models", "#{@options.name}.coffee"),
      @renderTemplate(path.join(@templatePath, "model.coffee.template"))

    @ensureDirectory path.join(@applicationPath, "app", "views", "#{@options.name}s")

    @addFile path.join(@applicationPath, "app", "views", "#{@options.name}s", "index.html"),
      @renderTemplate(path.join(@templatePath, "index.html.template"))


    @addFile path.join(@applicationPath, "app", "views", "#{@options.name}s", "show.html"),
      @renderTemplate(path.join(@templatePath, "show.html.template"))

    @addFile path.join(@applicationPath, "app", "views", "#{@options.name}s", "bootstrap.html"),
      @renderTemplate(path.join(@templatePath, "bootstrap.html.template"))


module.exports = Angular
