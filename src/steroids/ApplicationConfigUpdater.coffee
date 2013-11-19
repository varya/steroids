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
    console.log ""
    console.log "INSTALLING NPM DEPENDENCIES"
    console.log "==========================="
    console.log ""
    console.log "N.B. Versionless modules in package.json are NOT updated!"
    console.log ""

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

        if !@gruntfileContainsSteroids()
            console.log ""
            console.log "EXISTING GRUNTFILE.JS FOUND"
            console.log "==========================="
            console.log ""
            console.log "Breaking update ahead!"
            console.log "Steroids now uses Gruntfile.js directly from the project root directory."
            console.log "Since you already have a Gruntfile.js of your own, steroids update was unable"
            console.log "to enable default tasks for steroids."
            console.log ""
            console.log "MANUAL ACTION NEEDED:"
            console.log ""
            console.log "To use Steroids tasks, include both of the following lines in your Gruntfile.js:"
            console.log "   #{paths.application.steroidsLoadTasksString}"
            console.log "   grunt.registerTask('default', ['steroids-make', 'steroids-compile-sass']);"
            console.log ""
            console.log "To get rid of this message without enabling Steroids tasks, include the lines"
            console.log "to your Gruntfile.js and comment them out."
            console.log ""
            console.log "See also: #TODO GUIDE_URL_HERE"
            console.log ""
            promptUnderstood (understood) =>
              if understood != "I UNDERSTAND THIS"
                console.log ""
                console.log "ABORT!"
                console.log "======"
                console.log ""
                console.log "Please read the instructions again."
                console.log ""
                process.exit 1

              @emit "gruntfileUpgraded"

        else
          @emit "gruntfileUpgraded"

      else
        console.log "NEW FEATURE"
        console.log "==========="
        console.log ""
        console.log "Creating new Gruntfile.js from Steroids template."
        console.log "- You may now alter Steroids' Grunt tasks directly from your project's own Gruntfile.js."
        console.log ""
        fs.writeFileSync(paths.application.configs.grunt, fs.readFileSync(paths.templates.gruntfile))

        @emit "gruntfileUpgraded"

  upgradePackagejson: ->
    @checkPackagejson (packagejsonExists) =>
      if packagejsonExists

        if @packagejsonContainsSteroids()
          @emit "packagejsonUpgraded"

        else
          console.log ""
          console.log "EXISTING PACKAGE.JSON FOUND"
          console.log "==========================="
          console.log ""
          console.log "To install Steroids' Grunt dependencies in your project, issue the following command:"
          console.log "  npm install grunt-steroids --save-dev"
          console.log ""
          promptRunCommand (agreed) =>
            if agreed
              @installGruntSteroids =>
                console.log "Installed grunt-steroids."

                @emit "packagejsonUpgraded"

            else
              console.log ""
              console.log "ABORT!"
              console.log "======"
              console.log ""
              console.log "Please install grunt-steroids manually or run steroids update again."
              process.exit 1

              @emit "packagejsonUpgraded"

      else
        console.log "Creating new package.json from Steroids template."
        fs.writeFileSync(paths.application.configs.packagejson, fs.readFileSync(paths.templates.packagejson))
        @emit "packagejsonUpgraded"


  installGruntSteroids: (done) ->
    gruntRun = sbawn
      cmd: "npm"
      # TODO: Change this after grunt-steroids is published
      #args: ["install", "grunt-steroids", "--save-dev"]
      args: ["install", "git+ssh://git@github.com/AppGyver/grunt-steroids.git", "--save-dev"]
      stdout: true
      stderr: true

    gruntRun.on "exit", done


  checkPackagejson: (cb) ->
    fs.exists paths.application.configs.packagejson, cb

  checkGruntfileExists: (cb) ->
    fs.exists paths.application.configs.grunt, cb

  gruntfileContainsSteroids: ->
    gruntfileData = fs.readFileSync paths.application.configs.grunt, 'utf-8'
    return gruntfileData.indexOf(paths.application.steroidsLoadTasksString) > -1

  packagejsonContainsSteroids: ->
    packagejsonData = fs.readFileSync paths.application.configs.packagejson, 'utf-8'
    return packagejsonData.indexOf(paths.application.steroidsPackagejsonString) > -1

  promptYesNo = (message) -> (done) ->
    inquirer.prompt [
        {
          type: "confirm"
          name: "userAgreed"
          message: message,
          default: true
        }
      ], (answers) ->
        done answers.userAgreed

  promptInput = (message) -> (done) ->
    inquirer.prompt [
        {
          type: "input"
          name: "userAgreed"
          message: message
        }
      ], (answers) ->
        done answers.userAgreed

  promptUnderstood = promptInput "Write here with uppercase letters: I UNDERSTAND THIS"
  promptRunCommand = promptYesNo "Do you want to run this command now?"




module.exports = ApplicationConfigUpdater