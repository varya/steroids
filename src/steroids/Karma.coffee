paths = require "./paths"
path = require "path"
sbawn = require("./sbawn")
fs = require "fs"
util = require "util"

class Karma
  constructor: ()->
    @running = false

  init: =>
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

  ensureConfigExists: =>
    exists = fs.existsSync(paths.test.karma.configFilePath)
    unless exists
      util.log "Could not find karma configuration file. Please run steroids karma init to generate #{paths.test.karma.configFilePath}"
      process.exit(1)

  start: (options={})=>
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

module.exports = Karma