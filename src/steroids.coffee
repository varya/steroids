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

  detectLegacyBowerJSON: ->
    fs = require("fs")

    bowerConfig = paths.application.configs.bower

    if fs.existsSync(bowerConfig)
      contents = fs.readFileSync(bowerConfig).toString()
      if contents.match('steroids-js.git#0.3.5') or contents.match('steroids-js.git#0.3.6')
        Help.legacy.specificSteroidsJSDetected()
        process.exit(1)


  runSteroidsCommandSync: (cmd, options={})->
    # no merging objects :(
    options.exitOnFailure ?= true

    fullCmd = "steroids #{cmd}"
    util.log "Running: #{fullCmd}"

    output = execSync fullCmd, true

    console.log output.stdout

    unless output.stderr == ""
      console.log output.stderr
      if options.exitOnFailure
        process.exit 1

    return output.stderr == ""

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
    @detectLegacyBowerJSON()

    [firstOption, otherOptions...] = argv._

    if firstOption in ["serve", "connect"]
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

        console.log "Initializing Steroids project ... "
        process.chdir(folder)

        @runSteroidsCommandSync "make"
        @runSteroidsCommandSync "package"

        Help.logo()
        Help.welcome()

      when "push"
        if @runSteroidsCommandSync "make"
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

        Prompt = require("./steroids/Prompt")
        prompt = new Prompt
          context: @

        if argv.watch
          Watcher = require("./steroids/fs/watcher")

          pushAndPrompt = =>
            console.log ""
            util.log "File system change detected, pushing code to connected devices ..."

            @runSteroidsCommandSync "push", exitOnFailure: false
            prompt.refresh()

          watcher = new Watcher
            onCreate: pushAndPrompt
            onUpdate: pushAndPrompt

          watcher.watch("./app")
          watcher.watch("./www")
          watcher.watch("./config")


        server = @startServer callback: ()=>
          buildServer = new BuildServer
                              path: "/"

          server.mount(buildServer)

          @runSteroidsCommandSync "push"

          interfaces = server.interfaces()
          ips = server.ipAddresses()


          unless argv.qrcode?
            QRCode = require "./steroids/QRCode"
            qrcode = new QRCode("appgyver://?ips=#{encodeURIComponent(JSON.stringify(ips))}")
            qrcode.show()

            util.log "Waiting for client to connect, scan the QR code that is visible in the browser ..."

          setInterval () ->
            activeClients = 0;
            needsRefresh = false

            for ip, client of buildServer.clients
              delta = Date.now() - client.lastSeen

              if (delta > 2000)
                needsRefresh = true
                delete buildServer.clients[ip]
                console.log ""
                util.log "Client disconnected: #{client.ipAddress} - #{client.userAgent}"
              else if client.new
                needsRefresh = true
                activeClients++
                client.new = false

                console.log ""
                util.log "New client: #{client.ipAddress} - #{client.userAgent}"
              else
                activeClients++

            if needsRefresh
              util.log "Number of clients connected: #{activeClients}"
              prompt.refresh()

          , 1000

          prompt.connectLoop()



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

        @runSteroidsCommandSync "update"

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
