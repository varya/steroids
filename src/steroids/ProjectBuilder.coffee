EventEmitter = require("events").EventEmitter
fs = require "fs"
path = require "path"
Grunt = require "./Grunt"
Paths = require "./paths"
Zip = require("./fs/zip")


class ProjectBuilder extends EventEmitter
  constructor: ->
    @grunt = new Grunt process.cwd()
    @zip = new Zip Paths.dist, Paths.temporaryZip
    @on "onReload", @reload
    #@watcher = new Watcher({emitter: this, onChange: "onReload"})

  reload: ->
    @zipDistPath()

  #watchDistPath: ->
  #  console.log "Starting to watch dist path: #{Paths.dist}"
  #  @watcher.watch Paths.dist

  zipDistPath: ->
    console.log "Creating zip from dist path: #{Paths.dist}"
    @zip.create (timestamp) =>
      console.log "Generated zip from #{Paths.dist} to #{Paths.temporaryZip}"
      @latestZipTimestamp = timestamp

  make: ->
    throw "Cannot perform build: grunt.js file does not exist." unless @grunt.doesConfigFileExist()
    @grunt.run()
    @zipDistPath()

  ensureBuildFile: ->
    @grunt.createConfigFile() unless @grunt.doesConfigFileExist()

module.exports = ProjectBuilder