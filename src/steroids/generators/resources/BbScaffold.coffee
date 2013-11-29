Base = require "../Base"
chalk = require "chalk"

module.exports = class BbScaffold extends Base

  constructor: (@options) ->
    @args = "steroids:bb-scaffold"
    @opts = {}

  @usageParams: ->
    ""

  @usage: ()->
    """
    Generates an Backbone.js CRUD scaffold to work with a REST-API.

    For a resource named #{chalk.bold("car")}, the following files will be created:

        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/car/edit.html
        - app/views/car/new.html
        - app/views/layouts/car.html

    """
