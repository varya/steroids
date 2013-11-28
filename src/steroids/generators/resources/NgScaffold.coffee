Base = require "../Base"
chalk = require "chalk"

module.exports = class NgScaffold extends Base

  constructor: (@options) ->
    @args = "steroids:ng-scaffold"
    @opts = {}

  @usageParams: ->
    ""

  @usage: ()->
    """
    Generates an Angular.js CRUD scaffold to work with a REST-API.

    For a resource named #{chalk.bold("car")}, the following files will be created.

        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/car/edit.html
        - app/views/car/new.html
        - app/views/layouts/car.html

    """
