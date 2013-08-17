BuildServer = require "./servers/BuildServer"
PortChecker = require "./PortChecker"
Simulator = require "./Simulator"
Project = require "./Project"
QRCode = require "./QRCode"
Server = require "./Server"
paths = require "./paths"
sbawn = require "./sbawn"

argv = require('optimist').argv

path = require "path"
fs = require "fs"
util = require "util"

class Karma
  constructor: (opts={})->
    @running = false

    if opts.firstOption? and opts.firstOption is "init"
      @handleRequiredFiles()
      process.exit(1)

    @ensureConfigExists()

    @port = if opts.webServerPort?
      opts.webServerPort
    else
      4567

    checker = new PortChecker
      port: @port
      autorun: true
      onOpen: ()=>
        console.log "Error: port #{@port} is already in use. Make sure there is no other program or that 'steroids connect' is not running on this port."
        process.exit(1)
      onClosed: ()=>
        project = new Project
        project.push
          onFailure: =>
            steroidsCli.debug "Cannot continue starting server, the push failed."

          onSuccess: =>

            server = Server.start
              port: @port
              callback: ()=>

                global.steroidsCli.server = server

                # get karma port from karma.coffee
                require(paths.test.karma.configFilePath)(
                  set: (config)=>
                    @karmaPort = config.port
                  LOG_INFO: ""
                )

                buildServer = new BuildServer
                                    karmaPort: @karmaPort
                                    path: "/"
                                    port: @port

                server.mount(buildServer)

                unless opts.qrcode?
                  QRCode.showLocal
                    showTestContent: true
                    port: @port

                @startTestRun
                  onExit: (exitCode)->
                    steroidsCli.simulator.killall() if opts.simulator.use
                    process.exit(1)

                if opts.simulator.use
                  util.log "Please wait, launching simulator.."
                  steroidsCli.simulator.run
                    deviceType: opts.simulator.deviceType
                    stdout: false
                    stderr: false

  ensureConfigExists: =>
    exists = fs.existsSync(paths.test.karma.configFilePath)
    unless exists
      util.log "Could not find karma configuration file. Please run steroids karma init to generate #{paths.test.karma.configFilePath}"
      process.exit(1)

  startTestRun: (options={})=>
    if @running
      throw "Karma is already running."

    @running = true

    @karmaSession = sbawn
      cmd: paths.test.karma.binaryPath
      args: ["start", paths.test.karma.configFilePath]
      stdout: true
      stderr: true

    @karmaSession.on "exit", () =>
      @running = false

      options.onExit() if options.onExit?

  stop: =>
    @karmaSession.kill() if @karmaSession

  handleRequiredFiles: ()=>
    # app/test
    unless fs.existsSync(paths.test.basePath)
      util.log "Creating directory #{paths.test.basePath}"
      fs.mkdirSync paths.test.basePath
    # app/test/unit
    unless fs.existsSync(paths.test.unitTestPath)
      util.log "Creating directory #{paths.test.unitTestPath}"
      fs.mkdirSync paths.test.unitTestPath

    # karma.coffee
    if fs.existsSync(paths.test.karma.configFilePath)
      util.log "Karma config file #{paths.test.karma.configFilePath} already exists"
    else
      util.log "Creating karma config file #{paths.test.karma.configFilePath}"
      fs.writeFileSync(paths.test.karma.configFilePath, fs.readFileSync(paths.test.karma.templates.configPath))

    # spec example
    exampleSpecPath = path.join paths.test.unitTestPath, "exampleSpec.js"
    if fs.existsSync(exampleSpecPath)
      util.log "Example spec file #{exampleSpecPath} already exists"
    else
      util.log "Creating example spec file #{exampleSpecPath}"
      fs.writeFileSync(exampleSpecPath, fs.readFileSync(paths.test.karma.templates.exampleSpecPath))

module.exports = Karma