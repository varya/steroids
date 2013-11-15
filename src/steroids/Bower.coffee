fs = require "fs"
inquirer = require "inquirer"
path = require "path"
rimraf = require "rimraf"

paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  update: ->
    ensureConfigurationExists ->

      upgradeGruntfile ->
        console.log ""
        console.log "Ok, existing Gruntfile.js found, not creating one."
        console.log ""
        console.log "PLEASE NOTE: To use Steroids tasks, please include the following in your Gruntfile.js:"
        console.log "   grunt.loadNpmTasks('grunt-steroids-defaults');"
        console.log ""
        promptRunCommand (agreed) ->
          if !agreed
            haltOnError("Ok, you decided to stop.")()

          upgradePackagejson ->
            console.log ""
            console.log "Existing package.json found, not touching it."
            console.log "To include Steroid's grunt default tasks in your project, you need to issue the following command:"
            console.log "  npm install grunt-steroids --save-dev"
            console.log ""
            promptRunCommand (agreed) ->
              if agreed
                installGruntSteroids ->
                  console.log "Installed grunt-steroids"
              else
                console.log "Not running it"

              updateNpmPackages ->
              console.log "Installed NPM dependencies."
              console.log "N.B. Versionless modules package.json were NOT updated!"

      ensureMyProjectNotPresent ->
        console.log "Installing NPM Dependencies from package.json"
        bowerRun = sbawn
          cmd: paths.bower
          args: ["update"]
          stdout: true
          stderr: true

  configs = paths.application.configs
  myProjectFolder = path.join paths.application.wwwDir, "components", "myProject"

  updateNpmPackages = (done) ->
    npmRun = sbawn
      cmd: "npm"
      args: ["install"]
      stdout: true
      stderr: true


  upgradeGruntfile = (done) ->
    checkGruntfile (gruntfileExists) ->
      if gruntfileExists
        done()
      else
        console.log "Creating new Gruntfile.js from Steroids template."
        fs.writeFileSync(paths.application.configs.grunt, fs.readFileSync(paths.templates.gruntfile))

  upgradePackagejson = (done) ->
    checkPackagejson (packagejsonExists) ->
      if packagejsonExists
        done()
      else
        console.log "Creating new package.json from Steroids template."
        fs.writeFileSync(paths.application.configs.packagejson, fs.readFileSync(paths.templates.packagejson))


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
  checkGruntfile = (cb) -> fs.exists paths.application.configs.grunt, cb
  checkPackagejson = (cb) -> fs.exists paths.application.configs.packagejson, cb
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
  promptRunCommand = prompt "Do you want to run this command now?"

  haltOnError = (message) -> ->
    console.log "ERROR: #{message}"
    process.exit 1

  declareConfigurationMissing = haltOnError "Unable to continue without a bower.json file at project root."
  declareMyProjectBroken = haltOnError "Unable to continue with myProject folder present."

module.exports = Bower
