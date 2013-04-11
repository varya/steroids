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
    Generates a stub angular resource consisting of a controller, a model, an index view and associated list/details partials.

    Options:
      - resource: name of resource to use. example: car will result in the files app/controllers/car.js, app/models/car.js and views/car/index.html (and _list.html and _details.html)
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "angular")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.js"),
      path.join("app", "models", "#{@options.name}.js"),
      path.join("app", "views", "#{@options.name}", "index.html")
      path.join("app", "views", "#{@options.name}", "_list.html")
      path.join("app", "views", "#{@options.name}", "_details.html")
    ]

    @ensureDirectory path.join("app")

    @ensureDirectory path.join("app", "controllers")
    @addFile path.join("app", "controllers", "#{@options.name}.js"), "controller.js.template"
    
    @ensureDirectory path.join("app", "models")
    @addFile path.join("app", "models", "#{@options.name}.js"), "model.js.template"

    @ensureDirectory path.join("app", "views")
    
    @ensureDirectory path.join("app", "views", "layouts")
    @addLayout path.join("app", "views", "layouts", "application.html"), "layout.html.template"
    
    @ensureDirectory path.join("app", "views", "#{@options.name}")
    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_list.html"), "list.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_details.html"), "details.html.template"

    @addBowerDependency "angular", "1.0.6"

    util.log "Command completed successfully."


module.exports = Angular
