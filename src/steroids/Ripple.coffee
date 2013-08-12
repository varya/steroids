Paths = require("./paths")
sbawn = require "./sbawn"
os = require "os"

class Ripple
  @openExtensionFolder: ->
    if os.type() is "Darwin"
      sbawn
        cmd: "open"
        args: [Paths.ripple.extensionDirectory]

  @openInstructions: ->
    if os.type() is "Darwin"
      sbawn
        cmd: "open"
        args: [Paths.ripple.installInstructionsFile]

module.exports = Ripple
