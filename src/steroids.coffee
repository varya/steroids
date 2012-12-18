Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"

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

      when "debug"
        weinre = new Weinre
        weinre.run()

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

  install: =>
    fs = require "fs"

    banner = (fs.readFileSync("./support/banner")).toString()

    console.log banner

    console.log "installing ..."

    Installer = require "./steroids/Installer"

    installer = new Installer()
    installer.install()



module.exports =
  run: ->
    s = new Steroids
    s.parseOptions()
  install: ->
    s = new Steroids
    s.install()
  config: new Config


  Help: Help
  paths: require "./steroids/paths"


