steroids_simulators = require "steroids-simulators"
spawn = require("child_process").spawn

class Simulator
  constructor: (@options = {}) ->

  run: ->
    console.log "running #{steroids_simulators.iosSimPath}"
    console.log "with params -app #{steroids_simulators.latestSimulatorPath}"
    @simulatorProcess = spawn(steroids_simulators.iosSimPath, ["-app", steroids_simulators.latestSimulatorPath])

    @simulatorProcess.stdout.on "data", (d) ->
      console.log d.toString()

    @simulatorProcess.stderr.on "data", (d) ->
      console.log d.toString()

    @simulatorProcess.on 'exit', (code, signal)=>
      #TODO WHAT TO DO


module.exports = Simulator
