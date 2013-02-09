steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

class Simulator
  constructor: (@options = {}) ->

  run: ->
    console.log "running #{steroidsSimulators.iosSimPath}"
    console.log "with params -app #{steroidsSimulators.latestSimulatorPath}"
    @simulatorProcess = spawn(steroidsSimulators.iosSimPath, ["-app", steroidsSimulators.latestSimulatorPath])

    @simulatorProcess.stdout.on "data", (d) ->
      console.log d.toString()

    @simulatorProcess.stderr.on "data", (d) ->
      console.log d.toString()

    @simulatorProcess.on 'exit', (code, signal)=>
      #TODO WHAT TO DO


module.exports = Simulator
