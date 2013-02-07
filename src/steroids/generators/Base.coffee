steroids = require "../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"

class Base
  @usageParams: ->
    throw "generators.Base.usageParams not overrridden by subclass!"

  @usage: ->
    throw "generators.Base.usage not overridden by subclass!"

  constructor: (@options)->
    @options.className = @options.name[0].toUpperCase() + @options.name[1..-1]
    @applicationPath = steroids.paths.application

  renderTemplate: (templatePath)->
    template = fs.readFileSync(templatePath).toString()
    return ejs.render template,
      options: @options

  addFile: (filePath, contents)->
    fs.writeFileSync filePath, contents, "utf8"

  ensureDirectory: (dirPath)->
    if !fs.existsSync dirPath
      fs.mkdirSync dirPath

  generate: () ->
    throw "generators.Base#generate not overridden by subclass!"

module.exports = Base
