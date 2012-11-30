Help = require "./steroids/Help"
Weinre = require "./steroids/Weinre"


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

      when "debug"
        weinre = new Weinre
        weinre.run()

      else
        Help.usage()


module.exports =
  run: ->
    s = new Steroids
    s.parseOptions()

  Help: Help
  paths: require "./steroids/paths"


