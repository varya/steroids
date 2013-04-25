steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"


class Part2 extends Base
  @usageParams: ->
    ""

  @usage: ()->
    """
    Generates a walkthrough tutorial of Steroids

    TODO: better expl.
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("tutorial", @options.name))

  generate: ->

    # @checkForPreExistingFiles [
    #   path.join("app", "controllers", "application.js")
    #   path.join("app", "controllers", "tutorial.js")
    #   path.join("app", "views", "tutorial", "controllers.html")
    # ]


    @ensureDirectory path.join("app", "controllers")
    @copyFile path.join("app", "controllers", "application.js"), "application.js.template"
    @copyFile path.join("app", "controllers", "tutorial.js"), "tutorial.js.template"

    @copyFile path.join("app", "views", "tutorial", "controllers.html"), "controllers.html.template"
    @copyFile path.join("app", "views", "tutorial", "controllers-completed.html"), "controllers-completed.html.template"


    console.log "part 2 generated"
    console.log "now edit your first tab to point to http://localhost/views/tutorial/controllers.html"

module.exports = Part2
