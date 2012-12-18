Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"
Simulator = require "./steroids/Simulator"

util = require "util"
Config = require "./steroids/config"


class Steroids

  constructor: ->

  parseOptions: =>

    argv = require('optimist').argv

    [firstOption, otherOptions...] = argv._

    switch firstOption
      when "create"
        ProjectCreator = require("./steroids/ProjectCreator")

        projectCreator = new ProjectCreator(otherOptions)

        projectCreator.clone(otherOptions[0])
      when "make"
        ProjectBuilder = require("./steroids/ProjectBuilder")

        projectBuilder = new ProjectBuilder(otherOptions)

        projectBuilder.ensureBuildFile()
        projectBuilder.make()

      when "package"
        Packager = require "./steroids/Packager"

        packager = new Packager

        packager.create()

      when "debug"
        weinre = new Weinre
        weinre.run()

      when "simulator"
        simulator = new Simulator
        simulator.run()

      when "build"
        BuildServer = require "./steroids/servers/BuildServer"

        server = @startServer()

        buildServer = new BuildServer
                            path: "/"

        server.mount(buildServer)

        interfaces = server.interfaces()
        ips = server.ipAddresses()

        QRCode = require "./steroids/QRCode"
        qrcode = new QRCode("appgyver://?ips=#{encodeURIComponent(JSON.stringify(ips))}")
        qrcode.show()

        util.log "Waiting for client to connect, this may take a while ..."
      else
        Help.usage()


  startServer: =>
    Server = require "./steroids/Server"

    server = new Server
                    port: 4567
                    path: "/"

    server.listen()

    return server


module.exports =
  run: ->
    s = new Steroids
    s.parseOptions()
  config: new Config


  Help: Help
  paths: require "./steroids/paths"
