fs = require "fs"
inquirer = require "inquirer"
path = require "path"
rimraf = require "rimraf"

paths = require "./paths"
sbawn = require "./sbawn"

events = require "events"
Q = require "q"

class ApplicationConfigUpdater extends events.EventEmitter

  update: ->
    deferred = Q.defer()

    @on "applicationStart", @upgradeGruntfile
    @on "gruntfileUpgraded", @upgradePackagejson
    @on "packagejsonUpgraded", @updateNpmPackages
    @on "npmPackagesUpdated", deferred.resolve

    @emit "applicationStart"

    return deferred.promise


  updateNpmPackages: ->
    console.log "Installing NPM dependencies."
    console.log "N.B. Versionless modules package.json are NOT updated!"

    npmRun = sbawn
      cmd: "npm"
      args: ["install"]
      stdout: true
      stderr: true

    npmRun.on "exit", =>
      @emit "npmPackagesUpdated"


  upgradeGruntfile: ->
    @checkGruntfileExists (gruntfileExists) =>
      if gruntfileExists
        console.log "Ok, existing Gruntfile.js found, not creating one."

        if !@gruntfileContainsSteroids()
            console.log "PLEASE NOTE: To use Steroids tasks, include the following in your Gruntfile.js:"
            console.log "   #{paths.application.steroidsTasksString}"
            console.log ""
            console.log "To get rid of this message without enabling Steroids tasks, include the above line"
            console.log "to your Gruntfile.js and comment it out."
            console.log ""
            promptUnderstood (understood) =>
              if !understood
                console.log "You should read these confirmations. :)"

              @emit "gruntfileUpgraded"

        else
          @emit "gruntfileUpgraded"

      else
        console.log "Creating new Gruntfile.js from Steroids template."
        fs.writeFileSync(paths.application.configs.grunt, fs.readFileSync(paths.templates.gruntfile))

        @emit "gruntfileUpgraded"

  upgradePackagejson: ->
    @checkPackagejson (packagejsonExists) =>
      # TODO: Nag only if grunt-steroids not found
      if packagejsonExists
        console.log ""
        console.log "Existing package.json found, not touching it."
        console.log "To use Steroids' Grunt tasks in your project, you need to issue the following command:"
        console.log "  npm install grunt-steroids --save-dev"
        console.log ""
        promptRunCommand (agreed) =>
          if agreed
            @installGruntSteroids =>
              console.log "Installed grunt-steroids."
              @emit "packagejsonUpgraded"
          else
            console.log "Not installing grunt-steroids now. Plase run the command manually."
            console.log ""
            @emit "packagejsonUpgraded"

      else
        console.log "Creating new package.json from Steroids template."
        fs.writeFileSync(paths.application.configs.packagejson, fs.readFileSync(paths.templates.packagejson))
        @emit "packagejsonUpgraded"


  installGruntSteroids: (done) ->
    gruntRun = sbawn
      cmd: "npm"
      args: ["install", "grunt-steroids", "--save-dev"]
      stdout: true
      stderr: true

    gruntRun.on "exit", done


  checkPackagejson: (cb) ->
    fs.exists paths.application.configs.packagejson, cb

  checkGruntfileExists: (cb) ->
    fs.exists paths.application.configs.grunt, cb

  gruntfileContainsSteroids: ->
    gruntfileData = fs.readFileSync paths.application.configs.grunt, 'utf-8'
    return gruntfileData.indexOf(paths.application.steroidsTasksString) > -1

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

  promptUnderstood = prompt "I have read this."
  promptRunCommand = prompt "Do you want to run this command now?"




module.exports = ApplicationConfigUpdater