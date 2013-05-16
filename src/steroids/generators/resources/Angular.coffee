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
    Generates a stub Angular.js resource consisting of a controller, a model, an index view and associated partials for a list and details views.

    Options:
      - resource: name of resource to use. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/_list.html
        - app/views/car/_details.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "angular")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "controllers", "#{@options.name}.js"),
      path.join("app", "models", "#{@options.name}.js"),
      path.join("app", "views", "#{@options.name}", "index.html"),
      path.join("app", "views", "#{@options.name}", "_list.html"),
      path.join("app", "views", "#{@options.name}", "_details.html")
    ]

    @ensureDirectory path.join("www", "vendor")

    @ensureDirectory path.join("www", "vendor", "angular-hammer")
    @copyFile path.join("www", "vendor", "angular-hammer", "angular-hammer.js"), "angular-hammer.js.template"

    @ensureDirectory path.join("app")

    @ensureDirectory path.join("app", "controllers")
    @addFile path.join("app", "controllers", "#{@options.name}.js"), "controller.js.template"

    @ensureDirectory path.join("app", "models")
    @addFile path.join("app", "models", "#{@options.name}.js"), "model.js.template"

    @ensureDirectory path.join("app", "views")

    @ensureDirectory path.join("app", "views", "layouts")
    @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "angular-layout.html.template"

    @ensureDirectory path.join("app", "views", "#{@options.name}")
    @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_list.html"), "list.html.template"
    @addFile path.join("app", "views", "#{@options.name}", "_details.html"), "details.html.template"

    @addBowerDependency "angular", "1.0.6"

    util.log "Command completed successfully."


module.exports = Angular
