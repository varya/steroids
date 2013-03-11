steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")

class Simulator

  running: false

  constructor: (@options = {}) ->

  run: =>
    return false if @running

    @running = true

    console.log "running #{steroidsSimulators.iosSimPath}"
    console.log "with params -app #{steroidsSimulators.latestSimulatorPath}"

    @simulatorSession = sbawn
      cmd: steroidsSimulators.iosSimPath
      args: ["-app", steroidsSimulators.latestSimulatorPath]
      stdout: true
      stderr: true

    @simulatorSession.on "exit", () =>
      @running = false
      console.log "Killing iPhone Simulator ..." if @options.debug

      killSimulator = sbawn
        cmd: "/usr/bin/killall"
        args: ["iPhone Simulator"]

      killSimulator.on "exit", () =>
        console.log "killed." if @options.debug

  stop: () =>
    return false unless @running

    @simulatorSession.kill()


module.exports = Simulator
