steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")
Help = require "./Help"

paths = require "./paths"

os = require "os"

class UIAutomation

  running: false

  constructor: (@options = {}) ->

  run: (opts={}) =>
    unless os.type() == "Darwin"
      console.log "Error: UIAutomation requires Mac OS X."
      return false

    @stop()

    steroidsCli.debug "Running #{@options.script}.."

    @running = true

    cmd = "instruments"
    args = ["-D", "./tests/testTrace.trace",
            "-t", paths.instruments.automationTraceTemplatePath,
            steroidsSimulators.latestSimulatorPath,
            "-e", "UIASCRIPT", "#{@options.script}"]

    steroidsCli.debug "Spawning #{cmd}"
    steroidsCli.debug "with params: #{args}"

    @instrumentsSession = sbawn
      cmd: cmd
      args: args
      stdout: true
      stderr: true

    @instrumentsSession.on "exit", () =>
      @running = false

      steroidsCli.debug "Killing iOS UIAutomation ..."

      killSimulator = sbawn
        cmd: "/usr/bin/killall"
        args: ["iPhone Simulator"]

      killSimulator.on "exit", () =>
        steroidsCli.debug "killed."

  stop: () =>
    @instrumentsSession.kill() if @instrumentsSession


module.exports = UIAutomation
