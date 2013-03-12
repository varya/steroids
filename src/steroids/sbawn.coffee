spawn = require("child_process").spawn

class Sbawned

  constructor: (@options)->
    @_events = {}

    @done = false

  onStdoutData: (buffer) =>
    newData = buffer.toString()
    @stdout = @stdout + newData

    console.log newData if @options.debug or @options.stdout

  onStderrData: (buffer) =>
    newData = buffer.toString()

    if /^execvp\(\)/.test(newData)
      console.log "failed to sbawn with command: #{@options.cmd}" if @options.debug
      @onExit(-1)
      return

    @stderr = @stderr + newData
    console.log newData if @options.debug or @options.stderr

  onExit: (@code) =>
    @code = 137 unless @code
    @_performEvents "exit"

    @done = true

  sbawn: () =>
    args = @options.args
    args << "--debug" if steroidsCli.options.debug?

    @spawned = spawn @options.cmd, args, { cwd: @options.cwd }

    @spawned.stdout.on "data", @onStdoutData
    @spawned.stderr.on "data", @onStderrData
    @spawned.on "exit", @onExit

    process.on 'SIGINT', () =>
      @kill()

  kill: () =>
    @spawned.kill("SIGKILL")

  on: (event, callback) =>
    @_events[event] = [] unless @_events[event]
    @_events[event].push callback

  _performEvents: (event) =>
    for i of @_events[event]
      @_events[event][i].call() if @_events[event][i]

sbawn = (options={}) ->
  s = new Sbawned(options)
  s.sbawn()

  return s

module.exports = sbawn
