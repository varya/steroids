PortChecker = require "./PortChecker"
Project = require "./Project"
Help = require "./Help"
paths = require "./paths"
sbawn = require("./sbawn")

steroidsSimulators = require "steroids-simulators"

path = require "path"
fs = require "fs"
util = require "util"

class Appium
  constructor: (opts={})->
    @running = false
    if opts.init
      @handleRequiredFiles()
      process.exit(1)

    unless opts.filePath?
      Help.usage()
      process.exit(1)

    # always use 4567 because appium tests can only be run in simulator
    @port = "4567"

    checker = new PortChecker
      port: @port
      autorun: true
      onClosed: ()=>
        console.log "Error: steroids connect is not running in port #{@port}. Please run 'steroids connect' in default port (#{@port}) to run appium tests."
        process.exit(1)

      onOpen: ()=>
        project = new Project
        project.push
          onFailure: =>
            steroidsCli.debug "Cannot continue starting server, the push failed."
          onSuccess: =>
            # start appium server
            @startServer
              debug: opts.debug
              onExit: ()->
                steroidsCli.simulator.killall() if opts.exitSimulator

                process.exit(1)

            @runTest
              file: opts.filePath

  functionalTestPathExists: =>
    exists = fs.existsSync(paths.test.functionalTestPath)
    unless exists
      util.log "Could not find functional test directory. Please run steroids appium init to generate #{paths.test.functionalTestPath}"
    return exists

  startServer: (options={})=>
    if @running
      throw "Appium.io is already running."

    @running = true

    @appiumSession = sbawn
      cmd: paths.test.appium.binaryWrapperPath
      cwd: paths.test.appium.basePath
      args: [
        paths.test.appium.instrumentsClientPath,
        paths.test.appium.authorizeIOSPath
      ]
      stdout: if options.debug? then options.debug else false
      stderr: if options.debug? then options.debug else false

    @appiumSession.on "exit", () =>
      @running = false

      options.onExit() if options.onExit?
      @appiumRunnerSession.kill() if @appiumRunnerSession

  runTest: (options={})=>
    if options.file?
      absolutePathToFile = path.join paths.applicationDir, options.file
      util.log "Going to run '#{absolutePathToFile}' in appium.io.."

      cmd = paths.test.appium.runnerBinaryWrapperPath
      args = [steroidsSimulators.latestSimulatorPath, absolutePathToFile]

      util.log "Please wait, launching simulator.."
      @appiumRunnerSession = sbawn
        cmd: cmd
        args: args
        stdout: true
        stderr: true

      @appiumRunnerSession.on "exit", () =>
        util.log "Test run ended for '#{absolutePathToFile}'."
        @stop()
        options.onExit() if options.onExit?

    else
      throw "No test files specified. Syntax is: steroids test appium test/functional/mySpec.js"

  stop: =>
    @appiumSession.kill() if @appiumSession

  handleRequiredFiles: (opts={})=>
    # app/test
    unless fs.existsSync(paths.test.basePath)
      util.log "Creating directory #{paths.test.basePath}"
      fs.mkdirSync paths.test.basePath
    # app/test/functional
    unless fs.existsSync(paths.test.functionalTestPath)
      util.log "Creating directory #{paths.test.functionalTestPath}"
      fs.mkdirSync paths.test.functionalTestPath

    # spec example
    exampleSpecPath = path.join paths.test.functionalTestPath, "exampleSpec.js"
    if fs.existsSync(exampleSpecPath)
      util.log "Example spec file #{exampleSpecPath} already exists"
    else
      util.log "Creating example spec file #{exampleSpecPath}"
      fs.writeFileSync(exampleSpecPath, fs.readFileSync(paths.test.appium.templates.exampleSpecPath))

module.exports = Appium