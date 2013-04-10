Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"
Simulator = require "./steroids/Simulator"
Project = require "./steroids/Project"

util = require "util"
Version = require "./steroids/Version"
paths = require "./steroids/paths"

argv = require('optimist').argv
open = require "open"

class Steroids

  simulator: null

  constructor: (@options = {}) ->
    @simulator = new Simulator
      debug: @options.debug

    @version = new Version

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

  debug: (options = {}) =>
    return unless steroidsCli.options.debug

    message = if options.constructor.name == "String"
      options
    else
      options.message



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
        console.log "AppGyver Steroids #{@version.getVersion()}"

      when "create"
        if otherOptions[1]?
          template = otherOptions[0]
          folder = otherOptions[1]
        else
          template = "default"
          folder = otherOptions[0]

        ProjectCreator = require("./steroids/ProjectCreator")
        projectCreator = new ProjectCreator
          debug: @options.debug

        projectCreator.clone(folder, template)

        console.log "Initializing Steroids project ... "

        project = new Project
                    folder: folder
                    debug: @options.debug

        project.initialize
          onSuccess: () ->
            Help.logo()
            Help.welcome()


      when "push"
        project = new Project
        project.push
          onSuccess: ->
            steroidsCli.debug "steroids make && steroids package ok."


      when "make"
        project = new Project
        project.make()

      when "package"
        Packager = require "./steroids/Packager"

        packager = new Packager

        packager.create()

      when "grunt"
        # Grunt steals the whole node process ...
        Grunt = require("./steroids/Grunt")

        grunt = new Grunt
        grunt.run()

      when "debug"
        options = {}
        options.httpPort = argv.port

        weinre = new Weinre options
        weinre.run()

        project = new Project
        project.push
          onSuccess: () =>
            url = "http://localhost:#{weinre.options.httpPort}/client/#anonymous"
            steroidsCli.debug "pushed, opening browser to #{url}"
            open url


      when "simulator"
        steroidsCli.simulator.run()

      when "connect"

        project = new Project
        project.push
          onFailure: =>
            steroidsCli.debug "Can not continue on starting server, push failed."
          onSuccess: =>
            BuildServer = require "./steroids/servers/BuildServer"

            Prompt = require("./steroids/Prompt")
            prompt = new Prompt
              context: @

            if argv.watch
              Watcher = require("./steroids/fs/watcher")

              pushAndPrompt = =>
                console.log ""
                util.log "File system change detected, pushing code to connected devices ..."

                project = new Project
                project.push
                  onSuccess: =>
                    prompt.refresh()
                  onFailure: =>
                    prompt.refresh()

              watcher = new Watcher
                onCreate: pushAndPrompt
                onUpdate: pushAndPrompt
                onDelete: (file) =>
                  steroidsCli.debug "Deleted watched file #{file}"

              watcher.watch("./app")
              watcher.watch("./www")
              watcher.watch("./config")


            server = @startServer callback: ()=>
              global.steroidsCli.server = server

              buildServer = new BuildServer
                                  path: "/"

              server.mount(buildServer)

              unless argv.qrcode?
                QRCode = require "./steroids/QRCode"
                QRCode.showLocal()

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
        
        Bower = require "./steroids/Bower"
        bower = new Bower
        bower.update()

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
          util.log "ERROR: no authentication found, run steroids login first."
          process.exit 1

        unless Login.authTokenExists()
          util.log "ERROR: Canceling cloud build due to login failure"
          process.exit 1

        util.log "Building application locally"

        project = new Project
        project.make
          onSuccess: =>
            project.package
              onSuccess: =>
                Deploy = require "./steroids/deploy"
                deploy = new Deploy(otherOptions)
                deploy.uploadToCloud ()=>
                  # all complete
                  process.exit 0
              onFailure: =>
                console.log "Can not make package, not deploying to cloud."
          onFailure: =>
            console.log "Can not build project locally, not deploying to cloud."

      else
        Help.logo() unless argv.noLogo
        Help.usage()


module.exports =
  run: ->
    global.steroidsCli = new Steroids
      debug: argv.debug

    steroidsCli.execute()

  GruntDefaults: require "./steroids/GruntDefaults"
  Help: Help
  paths: paths
