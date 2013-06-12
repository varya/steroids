steroids = require "../../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../../Base"
Help = require "../../../Help"


class Begin extends Base

  templatePath: ->
    path.join(steroids.paths.templates.resources, path.join("tutorial", @options.name))

  generate: ->

    @checkForPreExistingFiles [
      path.join("www", "tutorial.html")
    ]

    @ensureDirectory path.join("www")

    @copyFile path.join("www", "tutorial.html"), "tutorial.html.template"

    Help.awesome()
    console.log """

    Great success!

    Next up, open the config/application.coffee file. Find the
    steroids.config.location property, which tells our app which
    HTML document it should load when it starts up. Let's change it:

      steroids.config.location = "tutorial.html"

    Save the file. Then, hit enter on the Steroids console, opened via
    $ steroids connect. You should see your app reload with further
    instructions.

    The following lines are the output of Bower, a package dependency
    management tool. Bower is configured with config/bower.json and
    run with

      $ steroids update

    Bower, do your job:
    """

module.exports = Begin
