steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class NgResource extends Base
  @usageParams: ->
    "<resourceName>"

  @usage: ()->
    """
    Generates an Angular.js resource with local data.

    Options:
      - resourceName: name of resource to create. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/layouts/car.html
        - www/data/car.json
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "ng-resource")

  generate: ->
    @checkForPreExistingFiles [
       path.join("app", "controllers", "#{@options.name}.js")
       path.join("app", "models", "#{@options.name}.js")
       path.join("app", "views", "#{@options.name}", "index.html")
       path.join("app", "views", "#{@options.name}", "show.html")
       path.join("app", "views", "layouts", "#{@options.name}.html")
       path.join("www", "data", "#{@options.name}.json")
       path.join("www", "data", "#{@options.name}", "1.json")
       path.join("www", "data", "#{@options.name}", "2.json")
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
     @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "ng-resource-layout.html.template"

     @ensureDirectory path.join("app", "views", "#{@options.name}")
     @addFile path.join("app", "views", "#{@options.name}", "index.html"), "index.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "show.html"), "show.html.template"

     @ensureDirectory path.join("www", "data")
     @ensureDirectory path.join("www", "data", @options.name)
     @addFile path.join("www", "data", "#{@options.name}.json"), "all.json"

     @addBowerDependency "angular", "1.0.7"

     @addBowerDependency "underscore", "1.5.1"
     @addBowerDependency "restangular", "1.0.7"


     Help.SUCCESS()
     console.log """

     Angular.js resouce generated with local data, set the location of your app to:

       "http://localhost/views/#{@options.name}/index.html"

     and then modify the data in "www/data/#{@options.name}.json"
     """


module.exports = NgResource
