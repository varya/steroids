Help = require "./steroids/Help"


class Steroids
  

  @npmPath = __dirname

  constructor: ->


  parseOptions: ->

    argv = require('optimist').argv

    [firstOption, otherOptions...] = argv._

    switch firstOption
      when "create"
        ProjectCreator = require("./steroids/ProjectCreator")

        projectCreator = new ProjectCreator(otherOptions)
        
        projectCreator.clone(otherOptions[0])

      else
        Help.usage()


module.exports =
  run: ->
    s = new Steroids
    s.parseOptions()

  Help: Help
  paths: require "./steroids/paths"


