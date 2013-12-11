semver = require "semver"
rimraf = require "rimraf"
path = require "path"
fs = require "fs"

paths = require "./paths"
sbawn = require "./sbawn"

events = require "events"
Q = require "q"
chalk = require "chalk"
Help = require "./Help"
inquirer = require "inquirer"

class ApplicationConfigUpdater extends events.EventEmitter

  validateSteroidsEngineVersion: (versionNumber)->
    semver.satisfies @getSteroidsEngineVersion(), versionNumber

  getSteroidsEngineVersion: ->
    packageJson = if fs.existsSync paths.application.configs.packageJson
      packageJsonContents = fs.readFileSync paths.application.configs.packageJson, 'utf-8'
      JSON.parse packageJsonContents

    packageJson?.engines?.steroids

  # 3.1.0 MIGRATION:
  # - cordova.js not loaded from /appgyver/
  # - package.json exists
  # - engines.steroids exists at "3.1.0"
  updateTo3_1_0: ->
    deferred = Q.defer()

    if @validateSteroidsEngineVersion(">=3.1.0")
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """
        #{chalk.bold("engine.steroids")} didn't match #{chalk.bold(">=3.1.0")} in #{chalk.bold("package.json")}.

        This is likely because your project was created with an older version of Steroids CLI. We will
        now run through a few migration tasks to ensure that your project functions correctly.

        """
      )

      promptConfirm().then( =>
        @checkCordovaJsPaths()
      ).then( =>
        @ensurePackageJsonExists()
      ).then( =>
        @ensureSteroidsEngineIsDefinedWithVersion("3.1.0")
      ).then( ->
        Help.SUCCESS()
        console.log chalk.green("Migration successful, moving on!")
        deferred.resolve()
      ).fail (msg)->
        msg = msg ||
          """
          \n#{chalk.bold.red("Migration aborted")}
          #{chalk.bold.red("=================")}

          Please read through the instructions again!

          """
        deferred.reject(msg)

    return deferred.promise

  # 3.1.4 MIGRATION
  # -
  updateTo3_1_4: ->
    deferred = Q.defer()

    if @validateSteroidsEngineVersion(">=3.1.4")
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """
        #{chalk.bold("engine.steroids")} was #{chalk.bold(@getSteroidsEngineVersion())} in #{chalk.bold("package.json")}, expected #{chalk.bold(">=3.1.4")}

        This is likely because your project was created with an older version of Steroids CLI. We will
        now run through a few migration tasks to ensure that your project functions correctly.

        """
      )

      promptConfirm().then( =>
        @updateTo3_1_0()
      ).then( =>
        @ensureGruntfileExists()
      ).then( =>
        @ensureGruntfileContainsSteroids()
      ).then( =>
        @ensureGeneratorDependency()
      ).then( =>
        @ensureSteroidsEngineIsDefinedWithVersion("3.1.4")
      ).then( =>
        Help.SUCCESS()
        console.log chalk.green("Migration successful, moving on!")
        deferred.resolve()
      ).fail (msg)->
        msg = msg ||
          """
          \n#{chalk.bold.red("Migration aborted")}
          #{chalk.bold.red("=================")}

          Please read through the instructions again!

          """
        deferred.reject(msg)

    return deferred.promise

  checkCordovaJsPaths: ->
    deferred = Q.defer()

    console.log(
      """
      \nFirst up, the load path for #{chalk.bold("cordova.js")} has changed in Steroids CLI v3.1.0. The deprecated path is

        #{chalk.underline.red("http://localhost/appgyver/cordova.js")}

      or any subfolder of localhost. The required path for Steroids CLI 3.1.0 and newer is

        #{chalk.underline.green("http://localhost/cordova.js")}

      We will now search through your project's HTML files to see if there are any deprecated load paths.

      """
    )

    promptConfirm().then( ->

      gruntSbawn = sbawn
        cmd: steroidsCli.pathToSelf
        args: ["grunt", "--task=check-cordova-js-paths"]
        stdout: true
        stderr: true

      gruntSbawn.on "exit", () =>
        if gruntSbawn.code == 137
          promptUnderstood().then( ->
            deferred.resolve()
          ).fail ->
            deferred.reject()
        else
          console.log("Failed to run Grunt task #{chalk.bold("check-cordova-js-paths")}.")
          process.exit(1)

    ).fail ->
      deferred.reject()

    return deferred.promise

  ensurePackageJsonExists: ->
    deferred = Q.defer()

    console.log(
      """
      \nNext, we're going to create a #{chalk.bold("package.json")} file in your project root. If there
      already exists one, we'll just add the #{chalk.bold("engines.steroids")} field with the correct
      version number.

      """
    )

    promptConfirm().then( ->

      if fs.existsSync paths.application.configs.packageJson
        console.log chalk.green("\n#{chalk.bold("package.json")} found in project root, moving on!\n")
        deferred.resolve()
      else
        console.log(
          """
            \n#{chalk.red.bold("Could not find package.json in project root")}
            #{chalk.red.bold("===========================================")}

            We could not find a #{chalk.bold("package.json")} file in project root. We will create the file now.

          """
        )

        promptConfirm().then( ->
          console.log("\nCreating #{chalk.bold("package.json")} in project root...")
          fs.writeFileSync paths.application.configs.packageJson, fs.readFileSync(paths.templates.packageJson)
          console.log("#{chalk.green("OK!")}")
          deferred.resolve()
        ).fail ->
          deferred.reject()
    ).fail( ->
      deferred.reject()
    )

    return deferred.promise

  ensureSteroidsEngineIsDefinedWithVersion: (version)->
    deferred = Q.defer()

    if @validateSteroidsEngineVersion(version)
      console.log("\n#{chalk.bold("engine.steroids")} in #{chalk.bold("package.json")} is #{chalk.bold(version)}, moving on!")
      deferred.resolve()
    else
      console.log("Setting #{chalk.bold("engine.steroids")} in #{chalk.bold("package.json")} to #{chalk.bold(version)}...")
      if fs.existsSync paths.application.configs.packageJson
        packageJsonData = fs.readFileSync paths.application.configs.packageJson, 'utf-8'
        packageJson = JSON.parse(packageJsonData)
        if !packageJson.engines?
          packageJson.engines = { steroids: version }
        else
          packageJson.engines.steroids = version

        packageJsonData = JSON.stringify(packageJson, null, 4);
        fs.writeFileSync paths.application.configs.packageJson, packageJsonData
        console.log chalk.green("OK!")
        deferred.resolve()
      else
        deferred.reject()

    return deferred.promise

  packagejsonContainsSteroidsEngine: ->
    packagejsonData = fs.readFileSync paths.application.configs.packagejson, 'utf-8'
    return packagejsonData.indexOf(steroidsPackagejsonString) > -1


  # 3.1.4 migration tasks
  ensureGruntfileExists: ->
    deferred = Q.defer()

    if fs.existsSync paths.application.configs.grunt
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """
        \n#{chalk.green.bold("New feature")}
        #{chalk.green.bold("===========")}

        To build the #{chalk.bold("dist/")} folder, Steroids now uses a Gruntfile.js file directly from the project
        root directory. The tasks are defined in the #{chalk.bold("grunt-steroids")} Grunt plugin, installed as a
        npm dependency.

        To learn more about the new Grunt setup, see:

          #{chalk.underline("http://guides.appgyver.com/steroids/guides/project_configuration/gruntfile")}

        We will first create the default #{chalk.bold("Gruntfile.js")} file to your project root.

        """
      )

      promptConfirm().then( ->

        console.log "\nCreating new #{chalk.bold("Gruntfile.js")} in project root..."

        fs.writeFileSync(paths.application.configs.grunt, fs.readFileSync(paths.templates.gruntfile))

        console.log chalk.green("OK!")

        deferred.resolve()

      ).fail ->
        deferred.reject()

      return deferred.promise

  ensureGruntfileContainsSteroids: ->
    deferred = Q.defer()

    gruntfileData = fs.readFileSync paths.application.configs.grunt, 'utf-8'

    if gruntfileData.indexOf("grunt.loadNpmTasks(\"grunt-steroids\")") > -1
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """
        #{chalk.red.bold("Existing Gruntfile.js doesn't load grunt-steroids tasks")}
        #{chalk.red.bold("=======================================================")}

        Breaking update ahead!

        To build the #{chalk.bold("dist/")} folder, Steroids now uses a #{chalk.bold("Gruntfile.js")} file directly from the
        project root directory. The tasks are defined in the #{chalk.bold("grunt-steroids")} Grunt plugin.

        #{chalk.red.bold("Manual action needed")}
        #{chalk.red.bold("====================")}

        Your existing #{chalk.bold("Gruntfile.js")} isn't loading the required Steroids tasks (defined in the
        #{chalk.bold("grunt-steroids")} Grunt plugin). To get rid of this message, add the following line to
        your #{chalk.bold("Gruntfile.js")} (we're installing the #{chalk.bold("grunt-steroids")} npm package next):

           #{chalk.blue(steroidsLoadTasksString)};

        Then, you must configure your default Grunt task to include the required Steroids tasks:

           #{chalk.blue("grunt.registerTask('default', ['steroids-make', 'steroids-compile-sass'])")}

        To read more about the new Grunt setup, see:

          #{chalk.underline("http://guides.appgyver.com/steroids/guides/project_configuration/gruntfile")}

        """
      )

      promptUnderstood().then( ->
        deferred.resolve()
      ).fail ->
        deferred.reject()


    return deferred.promise

  ensureGeneratorDependency: ->
    deferred = Q.defer()

    packagejsonData = fs.readFileSync paths.application.configs.packageJson, 'utf-8'
    if packagejsonData.indexOf("grunt-steroids") > -1
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """

        #{chalk.red.bold("Existing package.json found without grunt-steroids dependency")}
        #{chalk.red.bold("=============================================================")}

        Your existing #{chalk.bold("package.json")} file doesn't have the required #{chalk.bold("grunt-steroids")} Grunt
        plugin as a dependency.

        To install the #{chalk.bold("grunt-steroids")} npm package in your project, run the following command:

          #{chalk.bold("$ npm install grunt-steroids --save-dev")}

        """
      )
      promptRunNpmInstall().then( =>
        Npm = require "./Npm"
        npm = new Npm

        npm.install("grunt-steroids").then( ->
          console.log(
            """
            \n#{chalk.green("OK!")} Installed the #{chalk.bold("grunt-steroids")} npm package successfully.

            """
          )
          deferred.resolve()
        ).fail ->
          msg =
            """
            \nCould not install the #{chalk.bold("grunt-steroids")} npm package.

            Try running

              #{chalk.bold("$ steroids update")}

            again, or install the package manually with

              #{chalk.bold("$ npm install grunt-steroids --save-dev")}

            """
          deferred.reject(msg)
      ).fail (msg)->
        deferred.reject(msg)

    return deferred.promise

  # Inquirer utils

  promptConfirm = ->
    prompt "confirm", "Can we go ahead?", true

  promptUnderstood = ->
    prompt "input", "Write here with uppercase letters #{chalk.bold("I UNDERSTAND THIS")}", "I UNDERSTAND THIS"

  promptRunNpmInstall = ->
    prompt "input", "Write #{chalk.bold("npm install grunt-steroids")} to continue", "npm install grunt-steroids"

  prompt = (type, message, answer) ->
    deferred = Q.defer()

    inquirer.prompt [
        {
          type: type
          name: "userAnswer"
          message: message
        }
      ], (answers) ->
        if answers.userAnswer is answer
          deferred.resolve()
        else
          deferred.reject()

    return deferred.promise

module.exports = ApplicationConfigUpdater
