spawn = require("child_process").spawn

class CommandRunner

  constructor: (@options)->
    @cmd = @options.cmd
    @args = @options.args || []
    @cwd = @options.cwd || ""

    @timeout = @options.timeout || 3000

    @stdout = ""
    @stderr = ""
    @done = false
    @code = null

  run:() =>
    @spawned = spawn @cmd, @args, [ cwd: @cwd ]

    @spawned.stdout.on "data", (buffer) =>
      @stdout = @stdout + buffer.toString()

    @spawned.stderr.on "data", (buffer) =>
      @stderr = @stderr + buffer.toString()

    @spawned.on "exit", (code) =>
      @code = code
      @done = true

    waitsFor(()=>
      return @done
    , "CommandRunner: cmd never exited", @timeout)

module.exports = CommandRunner