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
    semver.satisfies @getSteroidsEngineVersion(), ">=#{versionNumber}"

  getSteroidsEngineVersion: ->
    fs.exists paths.application.configs.packageJson, (exists) ->
      if exists
        packageJsonData = fs.readFileSync paths.application.configs.packageJson, 'utf-8'
        pacakgeJson = JSON.parse(packageJsonData)
        return packageJson?.engines?.steroids?
      else
        return undefined

  updateTo3_1_0: ->
    deferred = Q.defer()

    Help.attention()
    console.log(
      """
      #{chalk.bold("engine.steroids")} didn't match #{chalk.bold("3.1.0")} in #{chalk.bold("package.json")}.

      This is likely because your project was created with an older version of Steroids CLI. We will
      now run through a few migration tasks to ensure that your project functions correctly.

      """
    )

    promptConfirm().then( =>
      @checkCordovaJsPath()
    ).then( =>
      #@ensurePackageJsonExists()
    ).then( =>
      #@ensureSteroidsEngineIsDefined()
    ).then( =>

    ).fail( =>
      deferred.reject("FAIL")
    )

    return deferred.promise

  checkCordovaJsPath: ->
    deferred = Q.defer()

    deferred.resolve()
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
            deferred.fail("#{chalk.bold.red("ABORTED:")} Please run the command and read the instructions again.")
        else
          deferred.fail("#{chalk.bold.red("ERROR:")} Could not run grunt task #{chalk.bold("check-cordova-js-paths")}.")

    ).fail ->
      msg =
        """
        \n#{chalk.bold.red("Migration aborted")}
        #{chalk.bold.red("=================")}

        Please read through the instructions again!

        """
      deferred.fail(msg)

    return deferred.promise

  ensurePackageJsonExists: ->
    deferred = Q.defer()

    fs.exists paths.application.configs.packageJson, (exists) ->
      if exists
        deferred.resolve()
      else
        Help.attention()
        console.log(
          """
            #{chalk.red.bold("Could not find package.json in project root")}
            #{chalk.red.bold("===========================================")}

            Could not find a #{chalk.bold("package.json")} file in project root. Starting from Steroids CLI v3.1.0,
            a #{chalk.bold("package.json")} file is required. We will create the file now.

          """
        )

        promptConfirm().then( ->
          fs.writeFileSync(paths.application.configs.packagejson, fs.readFileSync(path.join paths.templates.configs, "pre-steroids-engine-package.json"))
          deferred.resolve()
        ).fail ->
          deferred.reject "#{chalk.bold.red("ABORTED:")} Please run the command and read the instructions again."

    return deferred.promise

  # assumes a package.json file exists
  ensureSteroidsEngineIsDefined: ->
    deferred = Q.defer()

    @ensurePackageJsonExists().then( ->

    ).fail( ->
      msg =
        """
        #{chalk.red.bold("Could not find package.json in project root")}
        #{chalk.red.bold("===========================================")}

        Could not find a #{chalk.bold("package.json")} file in project root. We will create one now.

        """
      promptUnderstood (userUnderstood) =>
        if userUnderstood
          @createPackageJson().then ->
            deferred.resolve()

    )



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