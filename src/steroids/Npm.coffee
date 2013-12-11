sbawn = require "./sbawn"
chalk = require "chalk"
Q = require "q"

class Npm

  install: (args)->
    deferred = Q.defer()

    if args?
      console.log(
        """
        \n#{chalk.bold.green("Installing npm package #{args}")}
        #{chalk.bold.green("==============================")}

        Running #{chalk.bold("npm install #{args}")} to install a project dependency...
        If this fails, try running the command manually.
        """
      )
    else
      console.log(
        """
        \n#{chalk.bold.green("Installing npm dependencies")}
        #{chalk.bold.green("===========================")}

        Running #{chalk.bold("npm install")} to install project npm dependencies...
        If this fails, try running the command manually.

        """
      )

    argsToRun = ["install"]

    if args?
      argsToRun.push(args)

    npmRun = sbawn
      cmd: "npm"
      args: argsToRun
      stdout: true
      stderr: true

    npmRun.on "exit", =>
      deferred.resolve()

    return deferred.promise

module.exports = Npm
