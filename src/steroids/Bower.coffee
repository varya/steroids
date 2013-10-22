fs = require "fs"
inquirer = require "inquirer"
path = require "path"
rimraf = require "rimraf"

paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  update: ->
    ensureConfigurationExists ->
      ensureMyProjectNotPresent ->
        bowerRun = sbawn
          cmd: paths.bower
          args: ["update"]
          stdout: true
          stderr: true

  configs = paths.application.configs
  myProjectFolder = path.join paths.application.wwwDir, "components", "myProject"

  ensureMyProjectNotPresent = (done) ->
    checkMyProjectFolder (present) ->
      if not present
        done()
      else
        promptMyProjectFolderRemoval (userAgreed) ->
          if userAgreed
            deleteMyProjectFolder ->
              console.log "Deleted myProject folder."
              done()
          else
            declareMyProjectBroken()
  
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
                migrateLegacyConfiguration ->
                  console.log "Migrated bower.json file."
                  done()
              else
                declareConfigurationMissing()
          else
            declareConfigurationMissing()

  isDirectory = (path) -> (done) -> fs.lstat path, (err, stat) -> done (!err and stat.isDirectory())
  checkMyProjectFolder = isDirectory myProjectFolder
  deleteMyProjectFolder = (done) -> rimraf myProjectFolder, done

  checkConfiguration = (cb) -> fs.exists configs.bower, cb
  checkLegacyConfiguration = (cb) -> fs.exists configs.legacy.bower, cb
  migrateLegacyConfiguration = (cb) -> fs.rename configs.legacy.bower, configs.bower, cb

  prompt = (message) -> (done) ->
    inquirer.prompt [
        {
          type: "confirm"
          name: "userAgreed"
          message: message,
          default: true
        }
      ], (answers) ->
        done answers.userAgreed

  promptConfigurationMigration = prompt "Would you like to use your existing Bower configuration from #{configs.legacy.bower}?"
  promptMyProjectFolderRemoval = prompt "Due to our configuration mistake, there seems to be a myProject folder in Bower components. Remove #{myProjectFolder}?"

  haltOnError = (message) -> ->
    console.log "ERROR: #{message}"
    process.exit 1

  declareConfigurationMissing = haltOnError "Unable to continue without a bower.json file at project root."
  declareMyProjectBroken = haltOnError "Unable to continue with myProject folder present."

module.exports = Bower
