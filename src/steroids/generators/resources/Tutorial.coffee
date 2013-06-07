steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

tutorials =
  "begin": require("./Tutorials/begin")
  "steroids": require("./Tutorials/steroids")
  "controllers": require("./Tutorials/controllers")

class Tutorial extends Base
  @usageParams: ->
    "<tutorialName>"

  @usage: ()->
    """
    Generates the Steroids tutorials.

    It is highly recommended that tutorials are created and completed in order, see ordering below.

    Options:
      - tutorialName: name of the tutorial to generate.  Available tutorials (should be done in order):
        - begin -- The very basics of AppGyver Steroids, start here
        - steroids -- Basics of Steroids Native UI enhancements
          - controllers -- Basics of Controllers (requires the 'steroids' tutorial to be generated first)
    """

  generate: ->
    TutorialClass = tutorials[@options.name]

    unless TutorialClass
      console.log "Error: No such tutorial #{@options.name}, see 'steroids generate' for help."
      process.exit(1)

    tutorial = new TutorialClass @options
    tutorial.generate()

module.exports = Tutorial
