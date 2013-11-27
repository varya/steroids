fs = require "fs"
inquirer = require "inquirer"
path = require "path"
rimraf = require "rimraf"

paths = require "./paths"
sbawn = require "./sbawn"

events = require "events"
Q = require "q"
chalk = require "chalk"
Help = require "./Help"

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
    console.log(
      """
      \n#{chalk.bold.green("INSTALLING NPM DEPENDENCIES")}
      #{chalk.bold.green("===========================")}

      Running #{chalk.bold("npm install")} to install project npm dependencies...

      """
    )

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
          Help.attention()
          console.log(
            """
            #{chalk.red.bold("EXISTING GRUNTFILE.JS DOESN'T LOAD GRUNT-STEROIDS TASKS")}
            #{chalk.red.bold("=======================================================")}

            Breaking update ahead!

            To build the #{chalk.bold("dist/")} folder, Steroids now uses a Gruntfile.js file directly from the
            project root directory. The tasks are defined in the #{chalk.bold("grunt-steroids")} Grunt plugin.

            Your existing Gruntfile.js isn't loading the required Steroids tasks.

            #{chalk.red.bold("MANUAL ACTION NEEDED")}
            #{chalk.red.bold("====================")}

            You must load the tasks from the #{chalk.bold("grunt-steroids")} npm plugin in your Gruntfile.js:

               #{paths.application.steroidsLoadTasksString}

            Then, you must configure your default Grunt task to include the required Steroids tasks:

               grunt.registerTask('default', ['steroids-make', 'steroids-compile-sass']);

            To get rid of this message, make sure that the tasks from the #{chalk.bold("grunt-steroids")} plugin are
            loaded by Grunt.

            To read more about the new Grunt setup, see:

              #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/gruntfile")}

            """
          )
          promptUnderstood (understood) =>
            if understood != "I UNDERSTAND THIS"
              exitAfterUnderstandingFailed()
            @emit "gruntfileUpgraded"

        else
          @emit "gruntfileUpgraded"

      else
        Help.attention()
        console.log(
          """
          #{chalk.green.bold("NEW FEATURE")}
          #{chalk.green.bold("===========")}

          To build the #{chalk.bold("dist/")} folder, Steroids now uses a Gruntfile.js file directly from the
          project root directory. The tasks are defined in the #{chalk.bold("grunt-steroids")} Grunt plugin.

          We will now add the required Gruntfile.js to your project root from the default template. To read
          more about the new Grunt setup, see:

            #{chalk.underline("http://guides.appgyver.com/steroids/guides/steroids-js/gruntfile")}

          """
        )

        promptUnderstood (understood) =>
          if understood != "I UNDERSTAND THIS"
            exitAfterUnderstandingFailed()

          console.log(
            """
            \nCopying Gruntfile.js to product root...

            """
          )
          fs.writeFileSync(paths.application.configs.grunt, fs.readFileSync(paths.templates.gruntfile))
          @emit "gruntfileUpgraded"

  upgradePackagejson: ->
    @checkPackagejson (packagejsonExists) =>
      if packagejsonExists

        if @packagejsonContainsSteroids()
          @emit "packagejsonUpgraded"

        else
          Help.attention()
          console.log(
            """

            #{chalk.red.bold("EXISTING PACKAGE.JSON FOUND")}
            #{chalk.red.bold("===========================")}

            Your existing #{chalk.bold("package.json")} file doesn't have the required #{chalk.bold("grunt-steroids")}
            Grunt plugin as a dependency.

            To install the #{chalk.bold("grunt-steroids")} npm package in your project, run the following command:

              npm install grunt-steroids --save-dev

            """
          )
          promptRunCommand (agreed) =>
            if agreed
              @installGruntSteroids =>
                console.log(
                  """
                  \n#{chalk.green("OK!")} Installed the #{chalk.bold("grunt-steroids")} npm pacakge successfully.

                  """
                )

                @emit "packagejsonUpgraded"

            else
              Help.error()
              console.log(
                """
                #{chalk.red.bold("GRUNT-STEROIDS INSTALL ABORTED!")}
                #{chalk.red.bold("===============================")}

                Please install #{chalk.bold("grunt-steroids")} manually or run #{chalk.bold("$ steroids update")} again.

                """
              )
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

  promptUnderstood = promptInput "Write here with uppercase letters #{chalk.bold("I UNDERSTAND THIS")}"
  promptRunCommand = promptYesNo "Do you want to run this command now?"

  exitAfterUnderstandingFailed = ->
    Help.error()
    console.log(
      """
      #{chalk.red.bold("UPDATE ABORTED")}
      #{chalk.red.bold("==============")}

      Please read the instructions again.
      """
    )
    process.exit 1


module.exports = ApplicationConfigUpdater