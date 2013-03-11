Help = require "./Help"

class Prompt

  prompt: null

  constructor: (@options) ->
    @prompt = require('prompt')

    @prompt.message = " í ½í²Š  Steroids".magenta
    @prompt.delimiter = " "

    @prompt.start();

  refresh: () =>
    process.stdout.write @prompt.message + @prompt.delimiter + "command  ".grey

  cleanUp: () =>
    console.log "Shutting down Steroids ..."

    steroidsCli.simulator.stop()

    console.log "... done."


  connectLoop: =>

    console.log "\nHit [enter] to update code, type help for usage"

    onInput = (err, result) =>
      command = if result? and result.command?
        result.command
      else
        "quit"

      switch command
        when "quit", "exit", "q"
          @cleanUp()

          console.log "Bye"

          process.exit(0)
        when "", "push"
          console.log "Updating code to all connected devices ..."
          @options.context.runSteroidsCommandSync "push", exitOnFailure: false

        when "s", "sim", "simulator"
          console.log "Starting iPhone Simulator"

          steroidsCli.simulator.run()

        when "s s", "sim stop", "simulator stop"
          console.log "Stopping iPhone Simulator ..."

          console.log if steroidsCli.simulator.stop()
            "stopped."
          else
            "the iPhone Simulator is not running, can not stop."

          console.log "... done."

        when "help", "?", "usage"
          Help.connect()
        else
          console.log "Did not recognize input: #{result.command}, type help for usage."

      @connectLoop()

    @get
      onInput: onInput



  get: (options)->
    @prompt.get
      properties:
        command:
          message: ""
    , (options.onInput ? @options.onInput?)



module.exports = Prompt