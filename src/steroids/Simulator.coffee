steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")

class Simulator

  running: false

  constructor: (@options = {}) ->

  run: =>
    return false if @running

    @running = true

    cmd = steroidsSimulators.iosSimPath
    args = ["-app", steroidsSimulators.latestSimulatorPath]

    steroidsCli.debug "Spawning #{cmd}"
    steroidsCli.debug "with params: #{args}"

    @simulatorSession = sbawn
      cmd: cmd
      args: args
      stdout: true
      stderr: true

    @simulatorSession.on "exit", () =>
      @running = false
      steroidsCli.debug "Killing iPhone Simulator ..."

      killSimulator = sbawn
        cmd: "/usr/bin/killall"
        args: ["iPhone Simulator"]

      killSimulator.on "exit", () =>
        steroidsCli.debug "killed."

  stop: () =>
    return false unless @running

    @simulatorSession.kill()


module.exports = Simulator
