steroids = require "../../steroids"
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

class Base
  @usageParams: ->
    throw "generators.Base.usageParams not overrridden by subclass!"

  @usage: ->
    throw "generators.Base.usage not overridden by subclass!"

  constructor: (@options)->
    @options.className = @options.name[0].toUpperCase() + @options.name[1..-1]
    @applicationPath = steroids.paths.applicationDir

  checkForPreExistingFiles: (pathList)->
    for filePath in pathList
      if fs.existsSync path.join @applicationPath, filePath
        throw {
          fromSteroids: true
          message: "File at #{filePath} would be overwritten by this command. Remove the file to successfully run this command."
        }

  renderTemplate: (templatePath)->
    template = fs.readFileSync(templatePath).toString()
    return ejs.render template,
      options: @options

  addFile: (filePath, templatePath)->
    destinationPath = path.join @applicationPath, filePath
    sourcePath = path.join @templatePath(), templatePath

    util.log "Adding file #{destinationPath}"
    fs.writeFileSync destinationPath, @renderTemplate(sourcePath), "utf8"
    
  addLayout: (filePath, templatePath)->
    destinationPath = path.join @applicationPath, filePath
    sourcePath = path.join @templatePath(), templatePath

    util.log "Adding layout #{destinationPath}"
    if !fs.existsSync destinationPath
      fs.writeFileSync destinationPath, fs.readFileSync(sourcePath), "utf8"

  ensureDirectory: (dirPath)->
    destinationPath = path.join @applicationPath, dirPath

    if !fs.existsSync destinationPath
      util.log "Creating directory #{destinationPath}"
      fs.mkdirSync destinationPath

  addBowerDependency: (packageName, version)->
    bowerJSONString = fs.readFileSync steroids.paths.application.configs.bower, 'utf8'
    bowerJSON = JSON.parse bowerJSONString

    util.log "Adding bower dependency in config/bower.json to #{packageName} at version #{version}"
    bowerJSON.dependencies ||= {}
    bowerJSON.dependencies[packageName] = version

    fs.writeFileSync steroids.paths.application.configs.bower, JSON.stringify(bowerJSON)

  templatePath: ->
    throw "generators.Base#templatePath not overridden by subclass!"

  generate: ->
    throw "generators.Base#generate not overridden by subclass!"

module.exports = Base
