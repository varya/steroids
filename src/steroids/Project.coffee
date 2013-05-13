sbawn = require "./sbawn"

class Project

  constructor: (@options={}) ->

  initialize: (options={}) =>
    process.chdir(@options.folder)

    @make
      onSuccess: =>
        @package(options.onSuccess)

  push: (options = {}) =>
    steroidsCli.debug "Starting push"

    @make
      onSuccess: =>
        @package
          onSuccess: () =>
            options.onSuccess.call() if options.onSuccess?
      onFailure: options.onFailure


  make: (options = {}) =>

    steroidsCli.debug "Spawning steroids grunt"

    gruntSbawn = sbawn
      cmd: steroidsCli.pathToSelf
      args: ["grunt"]
      stdout: true
      stderr: true

    gruntSbawn.on "exit", () =>
      if gruntSbawn.code == 137
        options.onSuccess.call() if options.onSuccess?
      else
        steroidsCli.debug "grunt spawn exited with code #{gruntSbawn.code}"
        options.onFailure.call() if options.onFailure?


  package: (options = {}) =>
    steroidsCli.debug "Spawning steroids package"

    packageSbawn = sbawn
      cmd: steroidsCli.pathToSelf
      args: ["package"]
      stdout: true
      stderr: true

    packageSbawn.on "exit", options.onSuccess

module.exports = Project