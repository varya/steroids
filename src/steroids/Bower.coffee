fs = require "fs"
path = require "path"

paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  configs = paths.application.configs

  update: ->
    checkObsoleteConfiguration ->
      bowerRun = sbawn
        cmd: paths.bower
        args: ["update"]
        stdout: true
        stderr: true

  checkObsoleteConfiguration = (done) ->
    fs.exists configs.bower,
      (isConfigured) =>
        if isConfigured
          done()
        else
          console.log "Bower configuration not found at #{configs.bower}"
          migrateObsoleteConfiguration done

  migrateObsoleteConfiguration = (done) ->
    fs.exists configs.legacy.bower,
      (hasLegacyConfiguration) =>
        if hasLegacyConfiguration
          console.log "Moving Bower configuration from #{configs.legacy.bower} to #{configs.bower}"
          fs.rename configs.legacy.bower,
            configs.bower,
            done
        else
          console.log "ERROR: Unable to continue without a bower.json file"
          process.exit 1

module.exports = Bower
