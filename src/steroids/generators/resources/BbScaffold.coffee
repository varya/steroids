steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class NgScaffold extends Base
  @usageParams: ->
    "<resourceName>"

  @usage: ()->
    """
    Generates an Backbone.js CRUD scaffold to work with a REST-API.

    Options:
      - resourceName: name of resource to create. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/car/edit.html
        - app/views/car/new.html
        - app/views/layouts/car.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "bb-scaffold")

  generate: ->
    @checkForPreExistingFiles [
       path.join("app", "controllers", "#{@options.name}.js")
       path.join("app", "models", "#{@options.name}.js")
       path.join("app", "views", "#{@options.name}", "index.html")
       path.join("app", "views", "#{@options.name}", "show.html")
       path.join("app", "views", "#{@options.name}", "edit.html")
       path.join("app", "views", "#{@options.name}", "new.html")
       path.join("app", "views", "layouts", "#{@options.name}.html")
     ]

     @ensureDirectory path.join("www", "vendor")

     @ensureDirectory path.join("www", "vendor", "hammerjs")
     @copyFile path.join("www", "vendor", "hammerjs", "jquery.hammer.min.js"), "jquery.hammer.min.js.template"

     @ensureDirectory path.join("app")

     @ensureDirectory path.join("app", "controllers")
     @addFile path.join("app", "controllers", "#{@options.name}.js"), "controller.js.template"

     @ensureDirectory path.join("app", "models")
     @addFile path.join("app", "models", "#{@options.name}.js"), "model.js.template"

     @ensureDirectory path.join("app", "views")

     @ensureDirectory path.join("app", "views", "layouts")
     @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "bb-rest-layout.html.template"

     @ensureDirectory path.join("app", "views", "#{@options.name}")
     @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "new.html"), "new.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "edit.html"), "edit.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "show.html"), "show.html.template"

     @addBowerDependency "jquery", "2.0.x"

     @addBowerDependency "underscore", "1.5.1"
     @addBowerDependency "backbone", "1.0.x"


     Help.SUCCESS()
     console.log """

     Backbone.js CRUD REST scaffold generated, set the location of your app to:

       "http://localhost/views/#{@options.name}/index.html"

     """


module.exports = NgScaffold
