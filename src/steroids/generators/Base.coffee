steroids = require "../../steroids"
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"
inquirer = require "inquirer"

class Base
  @usageParams: ->
    throw "generators.Base.usageParams not overrridden by subclass!"

  @usage: ->
    throw "generators.Base.usage not overridden by subclass!"

  constructor: (@options)->
    unless @options.name
      console.log "Error: missing name of the generator, see 'steroids generate' for help."
      process.exit(1)

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

  copyFile: (filePath, templatePath)->
    destinationPath = path.join @applicationPath, filePath
    sourcePath = path.join @templatePath(), templatePath

    util.log "Adding file #{destinationPath}"
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

  migrateBowerJsonLocation: ->
    unless fs.existsSync(path.join @applicationPath, "bower.json")
      question =
        type: "confirm"
        name: "moveFiles"
        message: "bower.json has migrated from config/bower.json to project root. Select Y to move the file automatically or N to exit the generator (your Bower dependencies for this generator will not install)."
        default: false

      inquirer.prompt [question], (answers)->
        if moveFiles
          fs.rename(path.join(@applicationPath, "config", "bower.json"), path.join(@applicationPath, "bower.json"))

module.exports = Base
