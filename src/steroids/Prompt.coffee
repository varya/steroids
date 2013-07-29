Help = require "./Help"
paths = require("./paths")


class Prompt

  prompt: null

  constructor: (@options) ->
    @prompt = require('prompt')

    @prompt.message = "AppGyver ".cyan + "Steroids".magenta
    @prompt.delimiter = " "

    @prompt.start();

  refresh: () =>
    process.stdout.write @prompt.message + @prompt.delimiter + "command  ".grey

  cleanUp: () =>
    console.log "Shutting down Steroids ..."

    steroidsCli.simulator.stop()

    console.log "... done."


  connectLoop: =>

    console.log "\nHit [enter] to push updates, type `help` for usage"

    onInput = (err, result) =>
      command = if result? and result.command?
        result.command
      else
        "quit"

      [mainCommand, commandOptions...] = command.split(' ')

      switch mainCommand
        when "quit", "exit", "q"
          @cleanUp()

          console.log "Bye"

          process.exit(0)
        when "", "push", "p"
          console.log "Updating code on all connected devices ..."
          Project = require "./Project"

          project = new Project
          project.preMake
            onSuccess: =>
              project.make
                onSuccess: =>
                  project.postMake
                    onSuccess: =>
                      project.package
                        onSuccess: =>
                          @refresh()

        when "s", "sim", "simulator"

          if commandOptions[0] in ["s", "stop"]
            console.log "Stopping iOS Simulator ..."

            console.log if steroidsCli.simulator.stop()
              "stopped."
            else
              "the iOS Simulator is not running (not launched by this session?), can not stop."

            console.log "... done."

            break


          deviceType = if commandOptions[0]
            commandOptions[0]
          else if steroidsCli.options.argv.deviceType
            steroidsCli.options.argv.deviceType
          else
            steroidsCli.simulator.DEFAULT_DEVICE_TYPE

          console.log "Starting iOS Simulator of type `#{deviceType}`"

          steroidsCli.simulator.run
            deviceType: deviceType

        when "qr", "qr-code", "qrcode"
          QRCode = require "./QRCode"
          QRCode.showLocal
            port: steroidsCli.port

        when "e", "edit"

          editorCmd = steroidsCli.config.getCurrent().editor.cmd
          editorArgs = steroidsCli.config.getCurrent().editor.args

          acualArgs = if editorArgs
            editorArgs
          else
            [paths.applicationDir]

          acualCmd = if editorCmd
            editorCmd
          else
            "subl"

          sbawn = require "./sbawn"
          sbawn
            cmd: acualCmd
            args: acualArgs
            debug: true

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