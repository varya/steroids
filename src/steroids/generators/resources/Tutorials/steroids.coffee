steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"


class Steroids extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("tutorial", @options.name))

  generate: ->

    @checkForPreExistingFiles [
      path.join("config", "application.coffee")
      path.join("app", "views", "layouts", "steroidsTutorial.html")
      path.join("app", "views", "steroidsTutorial", "index.html")
      path.join("app", "views", "steroidsTutorial", "show.html")
    ]

    @ensureDirectory path.join("config")
    @copyFile path.join("config", "application.coffee"), "application.coffee.template"

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")

    @ensureDirectory path.join("app", "views", "layouts")
    @copyFile path.join("app", "views", "layouts", "steroidsTutorial.html"), "layout.html.template"

    @ensureDirectory path.join("app", "views", "steroidsTutorial")
    @copyFile path.join("app", "views", "steroidsTutorial", "index.html"), "index.html.template"
    @copyFile path.join("app", "views", "steroidsTutorial", "show.html"), "show.html.template"

    @addBowerDependency "jquery", "1.9.1"

    Help.awesome()
    console.log """

    Next up, edit config/application.coffee and uncomment some lines.  CoffeeScript is especially picky about extra
    spaces, so make sure you remove the extra space after that # character.

    Find line that says:

    # steroids.config.tabBar.enabled = true

    This enables the native navigation tab bar.  And also the array below that configures the tab bar contents:

    # steroids.config.tabBar.tabs = [
    #   {
    #   ...
    #   }
    # ]

    Then, hit enter on the Steroids console (or use the command $ steroids push) and you should see the application reload
    with tabs.
    
    Bower, do your magic!
    """

module.exports = Steroids
