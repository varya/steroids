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

    @checkCordovaJsPath().then( ->
      @ensurePackageJsonExists()
    ).then( ->
      #@ensureSteroidsEngineIsDefined()
    ).then( ->
      #@updateSteroidsEngineVersionTo "3.1.0"
    ).fail( ->
      deferred.reject("FAIL")
    )

    return deferred.promise

  checkCordovaJsPath: ->
    deferred = Q.defer()

    console.log("Searching for deprecated #{chalk.bold("cordova.js")} load paths in your project's HTML files...")

    allFiles = fs.readdirSync paths.applicationDir
    console.log allFiles


    return deferred.promise

  ensurePackageJsonExists: ->
    deferred = Q.defer()

    fs.exists paths.application.configs.packagejson, (exists) ->
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

        promptUnderstood.then( ->
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


  promptUnderstood = ->
    deferred = Q.defer

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