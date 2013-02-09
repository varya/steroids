Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"
Simulator = require "./steroids/Simulator"

util = require "util"
Version = require "./steroids/Version"
paths = require "./steroids/paths"

execSync = require "exec-sync"

argv = require('optimist').argv
open = require "open"

class Steroids

  constructor: ->

  detectLegacyProject: ->
    fs = require("fs")

    applicationConfig = path.join paths.application, "config", "application.coffee"

    if fs.existsSync(applicationConfig)
      contents = fs.readFileSync(applicationConfig).toString()
      if contents.match('Steroids = require "steroids"') or contents.match('module.exports = Steroids.config')
        Help.legacy.requiresDetected()
        process.exit(1)

      if contents.match('Steroids.config')
        Help.legacy.capitalizationDetected()
        process.exit(1)


  parseOptions: =>

    [firstOption, otherOptions...] = argv._

    if firstOption in ["create", "serve", "connect"]
      Help.logo() unless argv.noLogo

    if argv.version
      firstOption = "version"


    switch firstOption
      when "version"
        console.log "AppGyver Steroids #{Version.getVersion()}"

      when "create"
        if otherOptions[1]?
          template = otherOptions[0]
          folder = otherOptions[1]
        else
          template = "default"
          folder = otherOptions[0]

        ProjectCreator = require("./steroids/ProjectCreator")
        projectCreator = new ProjectCreator()
        projectCreator.clone(folder, template)

        console.log "Initializing project ... "
        process.chdir(folder)

        output = execSync "steroids update"
        console.log output

        output = execSync "steroids push"
        console.log output

        Help.logo()
        Help.welcome()

      when "push"
        output = execSync "steroids make", true

        if output.stderr != ""
          console.log output.stderr
          process.exit 1

        console.log output.stdout

        output = execSync "steroids package", true

        if output.stderr != ""
          console.log output.stderr
          process.exit 1

        console.log output.stdout

      when "make"

        ProjectBuilder = require("./steroids/ProjectBuilder")

        projectBuilder = new ProjectBuilder(otherOptions)

        projectBuilder.make()

      when "package"
        Packager = require "./steroids/Packager"

        packager = new Packager

        packager.create()

      when "debug"
        options = {}
        options.httpPort = argv.port

        weinre = new Weinre options
        weinre.run()

        execSync "steroids push"

        open "http://localhost:#{weinre.options.httpPort}/client/#anonymous"

      when "simulator"
        simulator = new Simulator
        simulator.run()

      when "connect"

        BuildServer = require "./steroids/servers/BuildServer"

        server = @startServer()

        buildServer = new BuildServer
                            path: "/"

        server.mount(buildServer)


        console.log execSync "steroids push"

        interfaces = server.interfaces()
        ips = server.ipAddresses()

        QRCode = require "./steroids/QRCode"
        qrcode = new QRCode("appgyver://?ips=#{encodeURIComponent(JSON.stringify(ips))}")
        qrcode.show()

        util.log "Waiting for client to connect, this may take a while ..."




        getInput = () ->
          prompt = require('prompt')
          prompt.message = "Steroids [hit enter to push] ".magenta
          prompt.delimiter = " > "
          prompt.start();

          prompt.get
            properties:
              input:
                message: "input"
          , (err, result) =>
            if result == undefined or result.input == "quit" or result.input == "exit" or result.input == "q"
              console.log "Bye"
              process.exit(0)

            switch result.input
              when "", "push"
                console.log "Updating code to all connected devices"
                output = execSync "steroids push", true
                console.log output.stdout
              else
                console.log "Did not recognize input: #{result.input}"

            getInput()

        getInput()

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

        open url

      when "update"
        DependencyUpdater = require "./steroids/DependencyUpdater"

        dependencyUpdater = new DependencyUpdater

        dependencyUpdater.update()

      when "generate"
        [generatorType, generatorArgs...] = otherOptions

        unless generatorType?
          Help.listGenerators()
          process.exit 0

        Generators = require "./steroids/Generators"

        generatorOptions =
          name: generatorArgs[0]
          otherOptions: generatorArgs

        generator = new Generators[generatorType](generatorOptions)

        generator.generate()

      when "login"
        Help.logo()

        Login = require "./steroids/Login"

        if Login.authTokenExists()
          util.log "Already logged in."
          return

        util.log "Starting login process"

        port = argv.port || 4567

        server = @startServer
          port: port

        login = new Login
          server: server
          port: port
        login.authorize()

      when "logout"
        Help.logo()

        Login = require "./steroids/Login"

        unless Login.authTokenExists()
          util.log "You're not logged in. Not logging out."
          return

        Login.removeAuthToken()

        util.log "Logged out."

      when "deploy"
        Help.logo()

        Deploy = require "./steroids/deploy"
        deploy = new Deploy(otherOptions)
        deploy.uploadToCloud()

      else
        Help.logo() unless argv.noLogo
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
    s = new Steroids
    s.detectLegacyProject()
    s.parseOptions()

  GruntDefaults: require "./steroids/GruntDefaults"
  Help: Help
  paths: paths

  version: Version.getVersion()
