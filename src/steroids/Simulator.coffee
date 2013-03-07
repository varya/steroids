steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")

class Simulator
  constructor: (@options = {}) ->

  run: ->
    console.log "running #{steroidsSimulators.iosSimPath}"
    console.log "with params -app #{steroidsSimulators.latestSimulatorPath}"

    sbawned = sbawn
      cmd: steroidsSimulators.iosSimPath
      args: ["-app", steroidsSimulators.latestSimulatorPath]
      stdout: true
      stderr: true

    sbawned.on "exit", () =>
      console.log "Killing iPhone Simulator ..."
      sbawn
        cmd: "/usr/bin/killall"
        args: ["iPhone Simulator"]



module.exports = Simulator
