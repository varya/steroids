steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class NgSqlScaffold extends Base
  @usageParams: ->
    "<resourceName>"

  @usage: ()->
    """
    Generates an Angular.js CRUD scaffold that uses Peristence.js and WebSQL as a backend, with
    an option to switch to Cordova's SQLite plugin.

    Options:
      - resourceName: name of resource to create. Example: 'car' will result in the following files:
        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/car/edit.html
        - app/views/car/new.html
        - app/views/layouts/car.html
        - www/stylesheest/car.css
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "ng-sqlite-scaffold")

  generate: ->
    @checkForPreExistingFiles [
       path.join("app", "controllers", "#{@options.name}.js")
       path.join("app", "models", "#{@options.name}.js")
       path.join("app", "views", "#{@options.name}", "index.html")
       path.join("app", "views", "#{@options.name}", "show.html")
       path.join("app", "views", "#{@options.name}", "edit.html")
       path.join("app", "views", "#{@options.name}", "new.html")
       path.join("app", "views", "layouts", "#{@options.name}.html")
       path.join("www", "stylesheets", "#{@options.name}.css")
     ]

     @ensureDirectory path.join("www", "vendor")

     @ensureDirectory path.join("www", "vendor", "angular-hammer")
     @copyFile path.join("www", "vendor", "angular-hammer", "angular-hammer.js"), path.join("components", "angular-hammer.js")
     
     @ensureDirectory path.join("www", "vendor", "persistencejs")
     @copyFile path.join("www", "vendor", "persistencejs", "persistence.js"), path.join("components", "persistence.js")
     @copyFile path.join("www", "vendor", "persistencejs", "persistence.store.sql.js"), path.join("components", "persistence.store.sql.js")
     @copyFile path.join("www", "vendor", "persistencejs", "persistence.store.websql.js"), path.join("components", "persistence.store.websql.js")
     
     @ensureDirectory path.join("www", "javascripts")
     @ensureDirectory path.join("www", "javascripts", "plugins")
     @copyFile path.join("www", "javascripts", "plugins", "sqliteplugin.js"), path.join("components", "sqliteplugin.js")
     @copyFile path.join("www", "javascripts", "plugins", "sqliteplugin.android.js"), path.join("components", "sqliteplugin.android.js")

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
     @addFile path.join("app", "views", "#{@options.name}", "new.html"), "new.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "edit.html"), "edit.html.template"
     @addFile path.join("app", "views", "#{@options.name}", "show.html"), "show.html.template"

     @ensureDirectory path.join("www", "stylesheets")
     @addFile path.join("www", "stylesheets", "#{@options.name}.css"), "stylesheet.css.template"

     @addBowerDependency "angular", "1.0.7"

     Help.SUCCESS()
     console.log """

     Angular.js CRUD SQLite scaffold generated, set the location of your app to:

       "http://localhost/views/#{@options.name}/index.html"

     To switch the database from WebSQL to Cordova's SQLite plugin, see the commented out
     code at app/models/#{@options.name}.js

     """


module.exports = NgSqlScaffold
