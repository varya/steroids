SteroidsJS = require "steroids-js"
path = require "path"
spawn = require("child_process").spawn

class DependencyUpdater

  update: ->
    fs = require "fs"

    console.log "updating ..."

    # steroids.js
    srcPath = SteroidsJS.steroidsJSPath
    dstPath = "www/javascripts/steroids.js"

    @copyProcess = spawn "cp", [srcPath, dstPath]

    @copyProcess.stdout.on "data", (d) ->
      console.log d.toString()

    @copyProcess.stderr.on "data", (d) ->
      console.log d.toString()

    @copyProcess.on 'exit', (code, signal)=>
      #TODO WHAT TO DO


module.exports = DependencyUpdater
