fs = require "fs"
path = require "path"
Grunt = require "./Grunt"
Paths = require "./paths"
Zip = require("./fs/zip")


class ProjectBuilder
  constructor: ->
    @grunt = new Grunt Paths.application

  make: ->
    throw "Cannot perform build: grunt.js file does not exist." unless @grunt.doesConfigFileExist()
    @grunt.run()

module.exports = ProjectBuilder