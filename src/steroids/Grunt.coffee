fs = require "fs"
path = require "path"
paths = require "./paths"
spawn = require("child_process").spawn

class Grunt
  constructor: (@workingPath)->

  run: ->
    # set steroids path to global namespace for grunt requires
    global.steroidsPath = paths.npm

    require(paths.includedGrunt).tasks ["default"],
      gruntfile: @configFilePath()
      verbose: true

  configFilePath: (workingPath = @workingPath) ->
    path.join workingPath, "grunt.js"

  doesConfigFileExist: ->
    fs.existsSync @configFilePath()


module.exports = Grunt
