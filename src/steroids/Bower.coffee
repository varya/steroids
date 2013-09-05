paths = require "./paths"
sbawn = require "./sbawn"


class Bower
  constructor: ->

  update: (cb)->

    bowerRun = sbawn
      cmd: paths.bower
      args: ["install", "--config", paths.application.configs.bower]
      stdout: true
      stderr: true

module.exports = Bower
