steroids = require "../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"


class Scaffold
  constructor: (@options)->
    @templatePath = path.join(steroids.paths.templates.generators, "scaffold")

    @options.resourceClassName = @options.resourceName[0].toUpperCase() + @options.resourceName[1..-1]

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


    fs.writeFileSync path.join(process.cwd(), "app", "controllers", "#{@options.resourceName}sController.coffee"), controller, "utf8"

    if !fs.existsSync path.join(process.cwd(), "app", "models")
      fs.mkdirSync path.join(process.cwd(), "app", "models")

    fs.writeFileSync path.join(process.cwd(), "app", "models", "#{@options.resourceName}.coffee"), model, "utf8"

    fs.mkdirSync path.join(process.cwd(), "app", "views", "#{@options.resourceName}s")

    fs.writeFileSync path.join(process.cwd(), "app", "views", "#{@options.resourceName}s", "index.html"), indexView, "utf8"
    fs.writeFileSync path.join(process.cwd(), "app", "views", "#{@options.resourceName}s", "show.html"), showView, "utf8"
    fs.writeFileSync path.join(process.cwd(), "app", "views", "#{@options.resourceName}s", "bootstrap.html"), bootstrapView, "utf8"

module.exports = Scaffold
