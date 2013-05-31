Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"
Simulator = require "./steroids/Simulator"
Project = require "./steroids/Project"
Updater = require "./steroids/Updater"
SupportChat = require "./steroids/SupportChat"

util = require "util"
Version = require "./steroids/Version"
paths = require "./steroids/paths"

argv = require('optimist').argv
open = require "open"

fs = require("fs")

Config = require "./steroids/Config"
Login = require "./steroids/Login"

class Steroids

  simulator: null

  constructor: (@options = {}) ->
    @simulator = new Simulator
      debug: @options.debug

    @version = new Version
    @pathToSelf = process.argv[1]
    @config = new Config

  readApplicationConfig: ->
    applicationConfig = paths.application.configs.application

    if fs.existsSync(applicationConfig)
      contents = fs.readFileSync(applicationConfig).toString()

    return contents

  detectSteroidsProject: ->
    return fs.existsSync(paths.application.configDir) and fs.existsSync(paths.application.wwwDir)

  detectLegacyProject: ->
    contents = @readApplicationConfig()
    return unless contents

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
    selectedPort = options.port ? @port

    errorCb = (err)=>
      if err.message.match /EADDRINUSE/
        util.log "ERROR: Port #{selectedPort} is already in use. You probably have already have another `steroids` command running on that port."
        process.exit 1
      else
        throw err

    server = new Server
      port: selectedPort
      path: "/"
      errorCallback: errorCb

    server.listen ()=>
      util.log "The server has now been started on port #{selectedPort}"
      options.callback()

    return server


  ensureProjectIfNeededFor: (command, otherOptions) ->
    if command in ["push", "make", "package", "grunt", "debug", "simulator", "connect", "serve", "update", "generate", "deploy"]

      return if @detectSteroidsProject()
      return if command == "generate" and otherOptions.length == 0    # displays usage

      console.log """
        Error: command '#{command}' requires to be run in a Steroids project directory.
      """

      process.exit(1)

  execute: =>
    @detectLegacyProject()
    @detectLegacyBowerJSON()

    [firstOption, otherOptions...] = argv._

    if argv.version
      firstOption = "version"

    @debugPort = if argv.debugPort
      argv.debugPort
    else
      31173


    @ensureProjectIfNeededFor(firstOption, otherOptions)

    if firstOption in ["serve", "connect", "create"]
      Help.logo() unless argv.noLogo

    if firstOption in ["connect", "serve", "deploy", "simulator"]
      unless Login.authTokenExists()
        console.log """

        You must be logged in, log in with:

        \t$ steroids login

        """
        process.exit 1

    switch firstOption
      when "version"
        updater = new Updater
          verbose: false

        updater.check
          from: "version"

        console.log @version.formattedVersion()

      when "create"
        if otherOptions[1]?
          template = otherOptions[0]
          folder = otherOptions[1]
        else
          template = "default"
          folder = otherOptions[0]

        if template == "tutorial"
          Help.attention()
          console.log """

          We changed the way tutorials work.  You can start tutorials by creating a new project and then,
          in the project directory type:

            $ steroids generate tutorial begin

          """

          process.exit(1)

        unless folder

          console.log "Usage: steroids create <directoryName>"

          process.exit(1)

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
        project.preMake
          onSuccess: =>
            project.make
              onSuccess: =>
                project.postMake()

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
        @port = if argv.port
          argv.port
        else
          31173

        options = {}
        options.httpPort = @port

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
        updater = new Updater
        updater.check
          from: "connect"

        @port = if argv.port
          argv.port
        else
          4567

        portscanner = require "portscanner"

        portscanner.checkPortStatus @port, 'localhost', (error, status) =>
          unless status == "closed"
            console.log "Error: port #{@port} is already in use. Make sure there is no other program or that 'steroids connect' is not running on this port."
            process.exit(1)

          project = new Project
          project.push
            onFailure: =>
              steroidsCli.debug "Can not continue starting server, the push failed."
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
                                    port: @port

                server.mount(buildServer)

                unless argv.qrcode?
                  QRCode = require "./steroids/QRCode"
                  QRCode.showLocal
                    port: @port

                  util.log "Waiting for the client to connect, scan the QR code visible in your browser ..."

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

        @port = if argv.port
          argv.port
        else
          4000

        servePort = @port
        url = "http://localhost:#{servePort}"

        WebServer = require "./steroids/servers/WebServer"

        server = @startServer
          port: servePort
          callback: ()=>
            webServer = new WebServer
              path: "/"

            server.mount(webServer)

            util.log "Serving application in #{url}"

            open url

      when "update"
        updater = new Updater
          verbose: true

        updater.check
          from: "update"

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

        unless Generators[generatorType]
          console.log "No such generator: #{generatorType}"
          process.exit(1)

        generator = new Generators[generatorType](generatorOptions)

        try
          generator.generate()
        catch error
          throw error unless error.fromSteroids?

          util.log "ERROR: #{error.message}"
          process.exit 1

        console.log """

         -- Running bower update --

        """

        Bower = require "./steroids/Bower"
        bower = new Bower
        bower.update()

      when "login"
        updater = new Updater
        updater.check
          from: "login"

        Help.logo()

        if Login.authTokenExists()
          util.log "Already logged in."
          return

        util.log "Starting login process"

        @port = if argv.port
          argv.port
        else
          13303

        server = @startServer
          port: @port
          callback: ()=>
            login = new Login
              server: server
              port: @port
            login.authorize()

      when "logout"
        Help.logo()

        unless Login.authTokenExists()
          util.log "Try logging in before you try logging out."
          return

        Login.removeAuthToken()

        Help.loggedOut()


      when "deploy"
        updater = new Updater
        updater.check
          from: "deploy"

        Help.logo()

        unless Login.authTokenExists()
          util.log "ERROR: no authentication found, run steroids login first."
          process.exit 1

        unless Login.authTokenExists()
          util.log "ERROR: Cancelling cloud build due to login failure"
          process.exit 1

        util.log "Building application locally"

        project = new Project
        project.make
          onSuccess: =>
            project.package
              onSuccess: =>
                Deploy = require "./steroids/Deploy"
                deploy = new Deploy(otherOptions)
                deploy.uploadToCloud ()=>
                  # all complete
                  process.exit 0
              onFailure: =>
                console.log "Can not create package, cloud deploy not possible."
          onFailure: =>
            console.log "Can not build project locally, cloud deploy not possible."

      when "chat"
        [nickName, otherChatArgs...] = otherOptions

        unless nickName
          console.log "Usage: steroids chat <yournickname>"
          process.exit(1)

        supportChat = new SupportChat(nickName)
        supportChat.open()

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
