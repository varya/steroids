steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"


class Part1 extends Base
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

    @checkForPreExistingFiles [
      path.join("config", "application.coffee")
    ]

    @copyFile path.join("config", "application.coffee"), "application.coffee.template"

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")

    @ensureDirectory path.join("app", "views", "layouts")
    @copyFile path.join("app", "views", "layouts", "application.html"), "layout.html.template"

    @ensureDirectory path.join("app", "views", "tutorial")
    @copyFile path.join("app", "views", "tutorial", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "tutorial", "show.html"), "show.html.template"


    Help.attention()
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"
    console.log "TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO"

module.exports = Part1
