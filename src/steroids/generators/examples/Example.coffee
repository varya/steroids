examples =
  "accelerometer": require("./accelerometer")
  # "animation": require("./animation")
  # "audio": require("./audio")
  # "camera": require("./camera")
  # "compass": require("./compass")
  # "device": require("./device")
  # "drawer": require("./drawer")
  # "drumMachine": require("./drumMachine")
  # "geolocation": require("./geolocation")
  # "layerStack": require("./layerStack")
  # "modal": require("./modal")
  # "notification": require("./notification")
  # "navigationBar": require("./navigationBar")
  # "photoGallery": require("./photoGallery")
  # "preload": require("./preload")
  # "storage": require("./storage")
  # "s3upload": require("./s3upload")

Base = require "../Base"

chalk = require "chalk"

class Example extends Base
  @usageParams: ->
    "<exampleName>"

  @usage: ()->
    """
    Generates an example demonstrating a Steroids feature.

    Options:
      - exampleName: name of the example to generate.

        Available Steroids examples:
        - animation -- Using native animations without moving to another document (iOS-only).
        - drawer -- Using the native Facebook-style drawer (iOS-only).
        - drumMachine -- Demonstrate Steroids Audio API via a kickin' drum machine.
        - layerStack -- Native navigation, page transitions and backstack handling.
        - modal -- Using the modal window.
        - navigationBar -- Using the native navigation bar.
        - photoGallery -- Use Cordova's Camera and File APIs and Steroids native
                          windowing to create a one-picture photo gallery.
        - preload -- Preload WebViews to have them available immediately.

        Available Cordova examples:
        - accelerometer -- Access the device's accelerometer.
        - audio -- Play back audio files through Cordova's Media API.
        - camera -- Access the device's camera and photo library.
        - compass -- Access the device's compass.
        - device -- Access the device properties.
        - geolocation -- Access the device's geolocation data.
        - notification -- Access native notifications.
        - storage -- Access Cordova's SQL Storage API.

        Other:
        - s3upload -- Uploading photos to s3
    """

  generate: ->
    ExampleClass = examples[@options.name]

    unless ExampleClass
      console.log "#{chalk.red.bold("Error:")}; No such example #{chalk.bold(@options.name)}, see #{chalk.bold("steroids generate")} for help."
      process.exit(1)

    example = new ExampleClass @options
    example.generate()


module.exports = Example