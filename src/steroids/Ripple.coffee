spawn = require("child_process").spawn
sbawn = require("./sbawn")
paths = require "./paths"

class Ripple

  running: false

  constructor: (@options = {}) ->
    @port = @options.port || 4400 
    @servePort = @options.servePort || 4000

  run: (opts={}) =>
    @stop()

    @running = true

    cmd = paths.rippleBinary
    args = ["emulate", "--remote", "http://localhost:#{@servePort}", "--port", @port]

    @rippleServer = sbawn
      cmd: cmd
      args: args
      stdout: true
      stderr: true

  stop: () =>
    @rippleServer.kill() if @rippleServer


module.exports = Ripple
