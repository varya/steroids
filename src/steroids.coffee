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

    applicationConfig = paths.application.configs.application

    if fs.existsSync(applicationConfig)
      contents = fs.readFileSync(applicationConfig).toString()
      if contents.match('Steroids = require "steroids"') or contents.match('module.exports = Steroids.config')
        Help.legacy.requiresDetected()
        process.exit(1)

      if contents.match('Steroids.config')
        Help.legacy.capitalizationDetected()
        process.exit(1)

  runSteroidsCommandSync: (cmd, options={})->
    # no merging objects :(
    options.exitOnFailure ?= true

    output = execSync "steroids #{cmd}", true

    console.log output.stdout

    if output.stderr != ""
      console.log output.stderr
      if options.exitOnFailure
        process.exit 1


  startServer: (options={}) =>
    Server = require "./steroids/Server"
    selectedPort = options.port ? 4567

    errorCb = (err)=>
      if err.message.match /EADDRINUSE/
        util.log "ERROR: Port #{selectedPort} is already in use. You probably have another `steroids connect` command running already."
        process.exit 1
      else
        throw err

    server = new Server
      port: selectedPort
      path: "/"
      errorCallback: errorCb

    server.listen ()=>
      util.log "Server started on port #{selectedPort}"
      options.callback()

    return server


  execute: =>
    @detectLegacyProject()

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

        @runSteroidsCommandSync "update"

        @runSteroidsCommandSync "push"

        Help.logo()
        Help.welcome()

      when "push"
        @runSteroidsCommandSync "make"

        @runSteroidsCommandSync "package"

      when "make"
        Grunt = require("./steroids/Grunt")

        grunt = new Grunt

        grunt.run()

      when "package"
        Packager = require "./steroids/Packager"

        packager = new Packager

        packager.create()

      when "debug"
        options = {}
        options.httpPort = argv.port

        weinre = new Weinre options
        weinre.run()

        @runSteroidsCommandSync "push"

        open "http://localhost:#{weinre.options.httpPort}/client/#anonymous"

      when "simulator"
        simulator = new Simulator
        simulator.run()

      when "connect"

        BuildServer = require "./steroids/servers/BuildServer"

        server = @startServer callback: ()=>
          buildServer = new BuildServer
                              path: "/"

          server.mount(buildServer)

          @runSteroidsCommandSync "push"

          interfaces = server.interfaces()
          ips = server.ipAddresses()

          QRCode = require "./steroids/QRCode"
          qrcode = new QRCode("appgyver://?ips=#{encodeURIComponent(JSON.stringify(ips))}")
          qrcode.show()

          util.log "Waiting for client to connect, scan the QR code that is visible in the browser ..."

          getInput = =>
            prompt = require('prompt')
            prompt.message = "Steroids [hit enter to update code] ".magenta
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
                  console.log "Updating code to all connected devices ..."
                  @runSteroidsCommandSync "push", exitOnFailure: false
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
          callback: ()=>
            webServer = new WebServer
              path: "/"

            server.mount(webServer)

            util.log "Serving application in #{url}"

            open url

      when "update"
        Bower = require "./steroids/Bower"

        bower = new Bower

        bower.update()

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

        try
          generator.generate()
        catch error
          throw error unless error.fromSteroids?

          util.log "ERROR: #{error.message}"
          process.exit 1

      when "login"
        Help.logo()

        Login = require "./steroids/Login"

        if Login.authTokenExists()
          util.log "Already logged in."
          return

        util.log "Starting login process"

        port = argv.port || 13303

        server = @startServer
          port: port
          callback: ()=>
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

        Login = require "./steroids/Login"
        unless Login.authTokenExists()
          @runSteroidsCommandSync "login"

        unless Login.authTokenExists()
          util.log "ERROR: Canceling cloud build due to login failure"
          process.exit 1

        util.log "Building application locally"
        @runSteroidsCommandSync "push"

        Deploy = require "./steroids/deploy"
        deploy = new Deploy(otherOptions)
        deploy.uploadToCloud ()=>
          # all complete
          process.exit 0

      else
        Help.logo() unless argv.noLogo
        Help.usage()


module.exports =
  run: ->
    s = new Steroids
    s.execute()

  GruntDefaults: require "./steroids/GruntDefaults"
  Help: Help
  paths: paths

  version: Version.getVersion()
