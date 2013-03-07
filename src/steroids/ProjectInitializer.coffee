sbawn = require "./sbawn"

class ProjectInitializer

  constructor: (@options={}) ->


  initialize: (options={}) =>
    process.chdir(@options.folder)

    @_runMake () =>
      @_runPackage(options.onSuccess)


  _runMake: (andThen) =>
    makeSbawn = sbawn
      cmd: "steroids"
      args: ["make"]
      stdout: true
      stderr: true

    makeSbawn.on "exit", andThen

  _runPackage: (andThen) =>
    packageSbawn = sbawn
      cmd: "steroids"
      args: ["package"]
      stdout: true
      stderr: true

    packageSbawn.on "exit", andThen

module.exports = ProjectInitializer