steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class NgTouchdbResource extends Base
  @usageParams: ->
    "<resourceName>"

  @usage: ()->
    """
    Generates an Angular.js resource that syncs data in an external CouchDB database with a local TouchDB database.

    Options:
      - resourceName: name of resource to create. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/layouts/car.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "ng-touchdb-resource")

  generate: ->
    @checkForPreExistingFiles [
       path.join("app", "controllers", "#{@options.name}.js")
       path.join("app", "models", "#{@options.name}.js")
       path.join("app", "views", "#{@options.name}", "index.html")
       path.join("app", "views", "#{@options.name}", "show.html")
       path.join("app", "views", "layouts", "#{@options.name}.html")
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
     @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "layout.html.template"

     @ensureDirectory path.join("app", "views", "#{@options.name}")
     @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "show.html"), "show.html.template"

     @addBowerDependency "angular", "1.0.7"
     @addBowerDependency "CornerCouch", "*"


     Help.SUCCESS()
     console.log """

     Angular.js resouce generated with local data, set the location of your app to:

       "http://localhost/views/#{@options.name}/index.html"

     and then open app/models/#{@options.name}.js and change the URL/credentials of 
     the external database to your own database.
     """


module.exports = NgTouchdbResource
