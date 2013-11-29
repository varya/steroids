Base = require "../Base"
chalk = require "chalk"

module.exports = class NgSqlScaffold extends Base

  constructor: (@options) ->
    @args = "steroids:ng-sql-scaffold"
    @opts = {}

  @usageParams: ->
    ""

  @usage: ()->
    """
    Generates an Angular.js CRUD scaffold that uses Peristence.js and WebSQL as a backend, with
    an option to switch to Cordova's SQLite plugin.

    For a resource named #{chalk.bold("car")}, the following files will be created:

        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/car/edit.html
        - app/views/car/new.html
        - app/views/layouts/car.html
        - www/stylesheest/car.css
    """
