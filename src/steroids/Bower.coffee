fs = require "fs"
inquirer = require "inquirer"
path = require "path"

paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  configs = paths.application.configs

  update: ->
    ensureConfigurationExists ->
      bowerRun = sbawn
        cmd: paths.bower
        args: ["update"]
        stdout: true
        stderr: true

  ensureConfigurationExists = (done) ->
    checkConfiguration (isConfigured) ->
      if isConfigured
        done()
      else
        console.log "Bower configuration not found at #{configs.bower}. Since v2.7.31, Steroids requires a bower.json file at project root."
        checkLegacyConfiguration (hasLegacyConfiguration) ->
          if hasLegacyConfiguration
            promptConfigurationMigration (userAgreed) ->
              if userAgreed
                console.log "Moving Bower configuration from #{configs.legacy.bower} to #{configs.bower}"
                migrateLegacyConfiguration done
              else
                declareConfigurationMissing()
          else
            declareConfigurationMissing()

  declareConfigurationMissing = ->
    console.log "ERROR: Unable to continue without a bower.json file at project root."
    process.exit 1

  promptConfigurationMigration = (done) ->
    inquirer.prompt [
        {
          type: "confirm"
          name: "useExisting"
          message: "Would you like to use your existing Bower configuration from #{configs.legacy.bower}?",
          default: true
        }
      ], (answers) ->
        done answers.useExisting

  checkConfiguration = (cb) -> fs.exists configs.bower, cb
  checkLegacyConfiguration = (cb) -> fs.exists configs.legacy.bower, cb
  migrateLegacyConfiguration = (cb) -> fs.rename configs.legacy.bower, configs.bower, cb

module.exports = Bower
