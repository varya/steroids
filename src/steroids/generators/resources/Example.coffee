steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

examples =
  "animation": require("./Examples/animation")
  "drawer": require("./Examples/drawer")
  # "layerStack": require("./Tutorials/layerStack")
  # "modal": require("./Tutorials/modal")
  # "navbar": require("./Tutorials/navigationBar")
  # "preload": require("./Tutorials/preload")

class Example extends Base
  @usageParams: ->
    "<exampleName>"

  @usage: ()->
    """
    Generates an example demonstrating a Steroids feature.

    Options:
      - exampleName: name of the example to generate.  Available examples:
        - animation -- Using native animations without moving to another document.
        - drawer -- Using the native Facebook-style drawer.
        - layerStack -- Native navigation, page transitions and backstack handling.
        - modal -- Using the modal window.
        - navigationBar -- Using the native navigation bar.
        - preload -- Preload WebViews to have them available immediately.
    """

  generate: ->

    ExampleClass = examples[@options.name]
    example = new ExampleClass @options
    example.generate()

module.exports = Example
