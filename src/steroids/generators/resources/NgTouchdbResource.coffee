Base = require "../Base"
chalk = require "chalk"

module.exports = class NgTouchdbResource extends Base

  constructor: (@options) ->
    @args = "steroids:ng-touchdb-resource"
    @opts = {}

  @usageParams: ->
    ""

  @usage: ()->
    """

    Generates an Angular.js resource that syncs data in an external CouchDB database with a local TouchDB database.
    iOS-only.

    For a resource named #{chalk.bold("car")}, the following files will be created:

        - app/controllers/car.js
        - app/models/car.js
        - app/views/car/index.html
        - app/views/car/show.html
        - app/views/layouts/car.html
    """
