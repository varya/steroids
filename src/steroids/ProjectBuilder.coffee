fs = require "fs"
path = require "path"
Grunt = require "./Grunt"


class ProjectBuilder
  constructor: ->
    @grunt = new Grunt process.cwd()

  make: ->
    throw "Cannot perform build: grunt.js file does not exist." unless @grunt.doesConfigFileExist()
    @grunt.run()

  ensureBuildFile: ->
    @grunt.createConfigFile() unless @grunt.doesConfigFileExist()

module.exports = ProjectBuilder