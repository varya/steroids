steroidsSimulators = require "steroids-simulators"
spawn = require("child_process").spawn

sbawn = require("./sbawn")
Help = require "./Help"

os = require "os"

class Simulator

  running: false

  constructor: (@options = {}) ->

  run: (opts={}) =>
    unless os.type() == "Darwin"
      console.log "Error: Simulator requires Mac OS X."
      return false

    return false if @running

    @running = true


    cmd = steroidsSimulators.iosSimPath
    args = ["launch", steroidsSimulators.latestSimulatorPath]

    switch opts.type
      when "ipad"
        args.push "--family", "ipad"
      when "ipad_retina"
        args.push "--family", "ipad", "--retina"
      when "iphone_retina_3_5_inch"
        args.push "--retina"
      when "iphone_retina_4_inch"
        args.push "--retina", "--tall"

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

      console.log "PROTIP: use steroids simutor --type to specify device type, see steroids usage for help."

      return unless ( @simulatorSession.stderr.indexOf('Session could not be started') == 0 )

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
