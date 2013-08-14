steroidsSimulators = require "steroids-simulators"
paths = require "./paths"
path = require "path"
sbawn = require("./sbawn")
fs = require "fs"
util = require "util"

class Appium
  constructor: ()->
    @running = false

  init: =>
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
    unless fs.existsSync(exampleSpecPath)
      util.log "Creating example spec file #{exampleSpecPath}"
      fs.writeFileSync(exampleSpecPath, fs.readFileSync(paths.test.appium.templates.exampleSpecPath))

  functionalTestPathExists: =>
    exists = fs.existsSync(paths.test.functionalTestPath)
    unless exists
      util.log "Could not find functional test directory. Please run steroids appium init to generate #{paths.test.functionalTestPath}"
    return exists

  start: (options={})=>
    if @running
      throw "Appium.io is already running."

    @running = true

    cmd = paths.test.appium.binaryWrapperPath
    args = [
      paths.test.appium.instrumentsClientPath,
      paths.test.appium.authorizeIOSPath
    ]

    @appiumSession = sbawn
      cmd: cmd
      cwd: paths.test.appium.basePath
      args: args
      stdout: true
      stderr: true

    @appiumSession.on "exit", () =>
      @running = false

      options.onExit() if options.onExit?

  runTest: (options={})=>
    if options.file?
      absolutePathToFile = path.join paths.applicationDir, options.file
      console.log "Going to run '#{absolutePathToFile}' in appium.io.."

      cmd = paths.test.appium.runnerBinaryWrapperPath
      args = [steroidsSimulators.latestSimulatorPath, absolutePathToFile]

      @appiumRunnerSession = sbawn
        cmd: cmd
        args: args
        stdout: true
        stderr: true

      @appiumRunnerSession.on "exit", () =>
        @running = false
        @stop() # kill server
        options.onExit() if options.onExit?

    else
      throw "No test files specified. Syntax is: steroids test appium test/functional/mySpec.js"

  stop: =>
    @appiumSession.kill() if @appiumSession

module.exports = Appium