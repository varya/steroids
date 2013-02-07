steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"

class Default
  constructor: (@options)->
    @templatePath = path.join(steroids.paths.templates.resources, "default")

    @options.className = @options.name[0].toUpperCase() + @options.name[1..-1]

  generate: () ->
    controllerTemplate = fs.readFileSync(path.join(@templatePath, "controller.coffee.template")).toString()
    controller = ejs.render controllerTemplate,
      options: @options

    modelTemplate = fs.readFileSync(path.join(@templatePath, "model.coffee.template")).toString()
    model = ejs.render modelTemplate,
      options: @options

    indexViewTemplate = fs.readFileSync(path.join(@templatePath, "index.html.template")).toString()
    indexView = ejs.render indexViewTemplate,
      options: @options

    showViewTemplate = fs.readFileSync(path.join(@templatePath, "show.html.template")).toString()
    showView = ejs.render showViewTemplate,
      options: @options

    bootstrapViewTemplate = fs.readFileSync(path.join(@templatePath, "bootstrap.html.template")).toString()
    bootstrapView = ejs.render bootstrapViewTemplate,
      options: @options

    applicationPath = steroids.paths.application

    fs.writeFileSync path.join(applicationPath, "app", "controllers", "#{@options.name}sController.coffee"), controller, "utf8"

    if !fs.existsSync path.join(applicationPath, "app", "models")
      fs.mkdirSync path.join(applicationPath, "app", "models")

    fs.writeFileSync path.join(applicationPath, "app", "models", "#{@options.name}.coffee"), model, "utf8"

    fs.mkdirSync path.join(applicationPath, "app", "views", "#{@options.name}s")

    fs.writeFileSync path.join(applicationPath, "app", "views", "#{@options.name}s", "index.html"), indexView, "utf8"
    fs.writeFileSync path.join(applicationPath, "app", "views", "#{@options.name}s", "show.html"), showView, "utf8"
    fs.writeFileSync path.join(applicationPath, "app", "views", "#{@options.name}s", "bootstrap.html"), bootstrapView, "utf8"

module.exports = Default
