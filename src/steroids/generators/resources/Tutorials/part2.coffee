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


    console.log "part 2 generated"

module.exports = Part2
