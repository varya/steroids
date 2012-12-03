fs = require "fs"
path = require "path"
paths = require "./paths"
spawn = require("child_process").spawn

class Grunt
  constructor: (@workingPath)->


  run: ->
    require(paths.includedGrunt).tasks ["default"],
      gruntfile: path.join @workingPath, 'grunt.js'
      verbose: true


  configFilePath: (workingPath = @workingPath) ->
    path.join workingPath, "grunt.js"

  steroidsConfigFilePath: paths.gruntFileTemplate

  doesConfigFileExist: ->
    fs.existsSync @configFilePath()

  createConfigFile: ->
    console.log "Creating config file #{@configFilePath()}"
    fs.writeFileSync @configFilePath(), @defaultConfigFileContent(), "utf8"


  defaultConfigFileContent: ->
    fs.readFileSync(@steroidsConfigFilePath, "utf8")




module.exports = Grunt