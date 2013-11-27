sbawn = require "./sbawn"
util = require "util"
paths = require "./paths"
chalk = require "chalk"
fs = require "fs"
Help = require "./Help"

class Project

  constructor: (@options={}) ->

  initialize: (options={}) =>

    process.chdir(@options.folder)
    @installDependencies(options.onSuccess)

  installDependencies: (options={}) =>
    Npm = require "./Npm"
    npm = new Npm
    npm.install().then ->
      options.onSuccess?.call()

  push: (options = {}) =>
    steroidsCli.debug "Starting push"

    @make
      onSuccess: =>
        @package
          onSuccess: () =>
            options.onSuccess.call() if options.onSuccess?
      onFailure: options.onFailure

  preMake: (options = {}) =>
    config = steroidsCli.config.getCurrent()

    if config.hooks.preMake.cmd and config.hooks.preMake.args

      util.log "preMake starting: #{config.hooks.preMake.cmd} with #{config.hooks.preMake.args}"

      preMakeSbawn = sbawn
        cmd: config.hooks.preMake.cmd
        args: config.hooks.preMake.args
        stdout: true
        stderr: true

      steroidsCli.debug "preMake spawned"

      preMakeSbawn.on "exit", =>
        errorCode = preMakeSbawn.code

        if errorCode == 137 and config.hooks.preMake.cmd == "grunt"
          util.log "command was grunt build which exists with 137 when success, setting error code to 0"
          errorCode = 0

        util.log "preMake done"

        if errorCode == 0
          options.onSuccess.call() if options.onSuccess?
        else
          util.log "preMake resulted in error code: #{errorCode}"
          options.onFailure.call() if options.onFailure?

    else
      options.onSuccess.call() if options.onSuccess?


  postMake: (options = {}) =>
    config = steroidsCli.config.getCurrent()

    if config.hooks.postMake.cmd and config.hooks.postMake.args

      util.log "postMake started"

      postMakeSbawn = sbawn
        cmd: config.hooks.postMake.cmd
        args: config.hooks.postMake.args
        stdout: true
        stderr: true

      postMakeSbawn.on "exit", =>
        util.log "postMake done"

        options.onSuccess.call() if options.onSuccess?
    else
      options.onSuccess.call() if options.onSuccess?

  makeOnly: (options = {}) => # without hooks

    if !fs.existsSync(paths.grunt.gruntFile)
      Help.error()
      console.log(
        """
        No #{chalk.bold("Gruntfile.js")} found in project root. Please run

          $ steroids update

        to generate the default Gruntfile. To learn more about the new Steroids Grunt setup, see:

          #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/gruntfile")}

        """
      )
      options.onFailure.call() if options.onFailure?

    else
      steroidsCli.debug "Spawning Grunt"

      gruntSbawn = sbawn
        cmd: "grunt"
        args: []
        stdout: true
        stderr: true

      gruntSbawn.on "exit", () =>
        if gruntSbawn.code == 137
          steroidsCli.debug "grunt spawn successful, exited with code 137"
          options.onSuccess.call() if options.onSuccess?
        else
          steroidsCli.debug "grunt spawn exited with code #{gruntSbawn.code}"
          options.onFailure.call() if options.onFailure?

  make: (options = {}) => # with pre- and post-make hooks

    steroidsCli.debug "Making with hooks."

    @preMake
      onSuccess: =>
        @makeOnly
          onSuccess: =>
            @postMake options

  package: (options = {}) =>
    steroidsCli.debug "Spawning steroids package"

    packageSbawn = sbawn
      cmd: steroidsCli.pathToSelf
      args: ["package"]
      stdout: true
      stderr: true

    packageSbawn.on "exit", =>
      steroidsCli.debug "package exited"
      options.onSuccess() if options.onSuccess

module.exports = Project