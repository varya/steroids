steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"

examples =
  "accelerometer": require("./Examples/accelerometer")
  "animation": require("./Examples/animation")
  "camera": require("./Examples/camera")
  "compass": require("./Examples/compass")
  "drawer": require("./Examples/drawer")
  "layerStack": require("./Examples/layerStack")
  "media": require("./Examples/media")
  "modal": require("./Examples/modal")
  "navigationBar": require("./Examples/navigationBar")
  "preload": require("./Examples/preload")

class Example extends Base
  @usageParams: ->
    "<exampleName>"

  @usage: ()->
    """
    Generates an example demonstrating a Steroids feature.

    Options:
      - exampleName: name of the example to generate.  
        
        Available Steroids examples:
        - animation -- Using native animations without moving to another document.
        - drawer -- Using the native Facebook-style drawer.
        - layerStack -- Native navigation, page transitions and backstack handling.
        - modal -- Using the modal window.
        - navigationBar -- Using the native navigation bar.
        - preload -- Preload WebViews to have them available immediately.
        
        Available Cordova examples:
        - accelerometer -- Using Cordova to access the device's accelerometer.
        - camera -- Using Cordova to access the device's camera and photo library.
        - compass -- Using Cordova to access the device's compass.
    """

  generate: ->

    ExampleClass = examples[@options.name]
    example = new ExampleClass @options
    example.generate()

module.exports = Example
