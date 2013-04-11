steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")
Help = require "./Help"

class Simulator

  running: false

  constructor: (@options = {}) ->

  run: =>
    return false if @running

    @running = true

    cmd = steroidsSimulators.iosSimPath
    args = ["launch", steroidsSimulators.latestSimulatorPath]

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

      return unless ( @simulatorSession.stderr.indexOf('Session could not be started: Error Domain=DTiPhoneSimulatorErrorDomain Code=1 "iOS Simulator failed to install the application."') == 0 )

      Help.attention()
      Help.resetiOSSim()

      setTimeout () =>
        resetSimulator = sbawn
                  cmd: steroidsSimulators.iosSimPath
                  args: ["start"]
                  debug: true
      , 250


  stop: () =>
    return false unless @running

    @simulatorSession.kill()


module.exports = Simulator
