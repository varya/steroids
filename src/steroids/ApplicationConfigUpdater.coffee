fs = require "fs"
inquirer = require "inquirer"
path = require "path"
rimraf = require "rimraf"
semver = require "semver"

paths = require "./paths"
sbawn = require "./sbawn"

events = require "events"
Q = require "q"
chalk = require "chalk"
Help = require "./Help"

class ApplicationConfigUpdater extends events.EventEmitter

  validateSteroidsEngineVersion: (versionNumber)->
    semver.satisfies @getSteroidsEngineVersion(), versionNumber

  getSteroidsEngineVersion: ->
    packageJson = if fs.existsSync paths.application.configs.packageJson
      packageJsonContents = fs.readFileSync paths.application.configs.packageJson, 'utf-8'
      JSON.parse packageJsonContents

    packageJson?.engines?.steroids

  updateTo3_1_0: ->
    deferred = Q.defer()

    if @validateSteroidsEngineVersion("3.1.0")
      deferred.resolve()
    else
      Help.attention()
      console.log(
        """
        #{chalk.bold("engine.steroids")} didn't match #{chalk.bold("3.1.0")} in #{chalk.bold("package.json")}.

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

  promptConfirm = ->
    deferred = Q.defer()

    inquirer.prompt [
        {
          type: "confirm"
          default: true
          name: "userAgreed"
          message: "Can we go ahead?"
        }
      ], (answers) ->
        if answers.userAgreed
          deferred.resolve()
        else
          deferred.reject()

    return deferred.promise

  promptUnderstood = ->
    deferred = Q.defer()

    inquirer.prompt [
        {
          type: "input"
          name: "userAgreed"
          message: "Write here with uppercase letters #{chalk.bold("I UNDERSTAND THIS")}"
        }
      ], (answers) ->
        if answers.userAgreed is "I UNDERSTAND THIS"
          deferred.resolve()
        else
          deferred.reject()

    return deferred.promise

module.exports = ApplicationConfigUpdater