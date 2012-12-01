Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"


class Steroids
  
  @server = undefined

  constructor: ->


  parseOptions: =>

    argv = require('optimist').argv

    [firstOption, otherOptions...] = argv._

    switch firstOption
      when "create"
        ProjectCreator = require("./steroids/ProjectCreator")

        projectCreator = new ProjectCreator(otherOptions)
        
        projectCreator.clone(otherOptions[0])

      when "debug"
        weinre = new Weinre
        weinre.run()

      when "transfer"
        @startServer()
        console.log "Waiting for client to connect, this may take a while.."

      else
        Help.usage()


  startServer: =>
    Server = require "./steroids/Server"

    @server = new Server
                    port: 4567

    @server.listen()    




module.exports =
  run: ->
    s = new Steroids
    s.parseOptions()

  Help: Help
  paths: require "./steroids/paths"


