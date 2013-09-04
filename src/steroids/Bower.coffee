paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  constructor: ->

  update: (cb)->
    #bower = require 'bower'
    #bower = bower.commands.install.line(["jep", "jep", "install", "config", ])

    bowerRun = sbawn
      cmd: paths.bower
      args: ["install", "--config", paths.application.configs.bower]

module.exports = Bower
