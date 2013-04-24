steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

tutorials =
  "part1": require("./Tutorials/part1")
  "part2": require("./Tutorials/part2")

class Tutorial extends Base
  @usageParams: ->
    "<tutorialName>"

  @usage: ()->
    """
    tutorialtodo
    """

  generate: ->

    TutorialClass = tutorials[@options.name]
    tutorial = new TutorialClass @options
    tutorial.generate()

module.exports = Tutorial
