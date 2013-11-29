sbawn = require "./sbawn"
chalk = require "chalk"
Q = require "q"

class Npm

  install: ->
    deferred = Q.defer()
    console.log(
      """
      \n#{chalk.bold.green("INSTALLING NPM DEPENDENCIES")}
      #{chalk.bold.green("===========================")}

      Running #{chalk.bold("npm install")} to install project npm dependencies...
      If this fails, try running the command manually.

      """
    )

    npmRun = sbawn
      cmd: "npm"
      args: ["install"]
      stdout: true
      stderr: true

    npmRun.on "exit", =>
      deferred.resolve()

    return deferred.promise

module.exports = Npm
