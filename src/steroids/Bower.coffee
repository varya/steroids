fs = require "fs"
path = require "path"


paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  constructor: ->

  update: ->
    @checkObsoleteConfiguration ->
      bowerRun = sbawn
        cmd: paths.bower
        args: ["update"]
        stdout: true
        stderr: true

  checkObsoleteConfiguration: (done) ->
    fs.exists paths.application.configs.bower,
      (isConfigured) =>
        if isConfigured
          done()
        else
          @migrateObsoleteConfiguration done

  migrateObsoleteConfiguration: (done) ->
    fs.rename paths.application.configs.legacy.bower,
      paths.application.configs.bower,
      done


module.exports = Bower
