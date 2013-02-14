# path = require "path"
# SteroidsJS = require "steroids-js"
# spawn = require("child_process").spawn

class Bower
  constructor: ->

  update: (cb)->
    bower = require 'bower'
    bower = bower.commands.install.line("jep", "jep", "install")

    bower.on "data", (data)->
      console.log data if data

    bower.on "end", (data)=>
      console.log data if data

    bower.on "error", (err)=>
      console.log err.message

    # fs = require "fs"
    #
    # console.log "updating ..."
    #
    # # steroids.js
    # srcPath = SteroidsJS.steroidsJSPath
    # dstPath = "www/javascripts/steroids.js"
    #
    # @copyProcess = spawn "cp", [srcPath, dstPath]
    #
    # @copyProcess.stdout.on "data", (d) ->
    #   console.log d.toString()
    #
    # @copyProcess.stderr.on "data", (d) ->
    #   console.log d.toString()
    #
    # @copyProcess.on 'exit', (code, signal)=>
    #   #TODO WHAT TO DO


module.exports = Bower
