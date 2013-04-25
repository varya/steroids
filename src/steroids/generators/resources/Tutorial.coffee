steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

tutorials =
  "begin": require("./Tutorials/begin")
  "controllers": require("./Tutorials/controllers")

class Tutorial extends Base
  @usageParams: ->
    "<tutorialName>"

  @usage: ()->
    """
    Generates the Steroids tutorials.

    It is highly recommended that tutorials are created and completed in order, see ordering below.

    Options:
      - tutorialName: name of the tutorial to generate.  Available tutorials:
        - begin -- The very basics of AppGyver Steroids, start here.
        - controllers -- Basics of Controllers
    """

  generate: ->

    TutorialClass = tutorials[@options.name]
    tutorial = new TutorialClass @options
    tutorial.generate()

module.exports = Tutorial
