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


  make: (options = {}) =>
    steroidsCli.debug "Spawning steroids make"

    makeSbawn = sbawn
      cmd: "steroids"
      args: ["make"]
      stdout: true
      stderr: true

    makeSbawn.on "exit", options.onSuccess

  package: (options = {}) =>
    steroidsCli.debug "Spawning steroids package"

    packageSbawn = sbawn
      cmd: "steroids"
      args: ["package"]
      stdout: true
      stderr: true

    packageSbawn.on "exit", options.onSuccess

module.exports = Project