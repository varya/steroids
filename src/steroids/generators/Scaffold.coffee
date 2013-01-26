steroids = require "../../steroids"
spawn = require("child_process").spawn
path = require "path"

class Scaffold
  constructor: (@options)->

  generate: () ->
    @copyProcess = spawn "cp", ["-r", path.join(steroids.paths.templates.generators, "scaffold")+"/", process.cwd()]

    @copyProcess.stdout.on "data", (d) ->
      console.log d.toString()

    @copyProcess.stderr.on "data", (d) ->
      console.log d.toString()

    @copyProcess.on 'exit', (code, signal)=>
      #TODO WHAT TO DO

module.exports = Scaffold
