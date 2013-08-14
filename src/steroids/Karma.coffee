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
    unless fs.existsSync(paths.test.karma.configFilePath)
      util.log "Creating karma config file #{paths.test.karma.configFilePath}"
      fs.writeFileSync(paths.test.karma.configFilePath, fs.readFileSync(paths.test.karma.templates.configPath))

    # spec example
    exampleSpecPath = path.join paths.test.unitTestPath, "exampleSpec.js"
    unless fs.existsSync(exampleSpecPath)
      util.log "Creating example spec file #{exampleSpecPath}"
      fs.writeFileSync(exampleSpecPath, fs.readFileSync(paths.test.karma.templates.exampleSpecPath))

  configExists: =>
    exists = fs.existsSync(paths.test.karma.configFilePath)
    unless exists
      util.log "Could not find karma configuration file. Please run steroids karma init to generate #{paths.test.karma.configFilePath}"
    return exists

  start: (options={})=>
    if @running
      throw "Karma is already running."

    @running = true

    cmd = paths.test.karma.binaryPath
    args = ["start", paths.test.karma.configFilePath]

    @karmaSession = sbawn
      cmd: cmd
      args: args
      stdout: true
      stderr: true

    @karmaSession.on "exit", () =>
      @running = false

      options.onExit() if options.onExit?

  stop: =>
    @karmaSession.kill() if @karmaSession

module.exports = Karma