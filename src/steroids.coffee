Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"
Simulator = require "./steroids/Simulator"

util = require "util"
Config = require "./steroids/config"

execSync = require "exec-sync"

argv = require('optimist').argv

class Steroids

  constructor: ->

  parseOptions: =>

    [firstOption, otherOptions...] = argv._

    switch firstOption
      when "create"
        folder = otherOptions[0]

        ProjectCreator = require("./steroids/ProjectCreator")
        projectCreator = new ProjectCreator(otherOptions)
        projectCreator.clone(folder)

        console.log "Initializing project ... "
        process.chdir(folder)

        output = execSync "steroids push --noLogo"
        console.log output

        Help.logo()
        Help.welcome()

      when "push"
        output = execSync "steroids make --noLogo"
        console.log output

        output = execSync "steroids package --noLogo"
        console.log output

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

      when "connect"
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

      when "serve"
        port = (argv.port || 13101)
        url = "http://localhost:#{port}"

        WebServer = require "./steroids/servers/WebServer"

        server = @startServer
                    port: port

        webServer = new WebServer
                          path: "/"

        server.mount(webServer)

        util.log "Serving application in #{url}"

        open = require "open"
        open url

      when "update"
        DependencyUpdater = require "./steroids/DependencyUpdater"

        dependencyUpdater = new DependencyUpdater

        dependencyUpdater.update()

      else
        Help.usage()


  startServer: (options={}) =>
    Server = require "./steroids/Server"

    server = new Server
                    port: options.port || 4567
                    path: "/"

    server.listen()

    return server


module.exports =
  run: ->
    Help.logo() unless argv.noLogo

    s = new Steroids
    s.parseOptions()
  config: new Config


  Help: Help
  paths: require "./steroids/paths"
