fs = require "fs"
path = require "path"
paths = require "./paths"
spawn = require("child_process").spawn

class Grunt
  constructor: ()->

  run: ->
    # set steroids path to global namespace for grunt requires
    global.steroidsPath = paths.npm

    require(paths.grunt.library).tasks ["default"],
      gruntfile: paths.grunt.gruntFile
      verbose: false

module.exports = Grunt
