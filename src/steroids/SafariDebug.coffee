paths = require "./paths"
path = require "path"
sbawn = require("./sbawn")

class SafariDebug

  open: =>
    scriptPath = path.join paths.scriptsDir, "openSafariDevMenu.scpt"

    openSafariDebug = sbawn
      cmd: "osascript"
      args: [scriptPath]

    openSafariDebug.on "exit", () =>
      steroidsCli.debug "SafariDebug started and killed."
      steroidsCli.debug "stderr: " + openSafariDebug.stderr
      steroidsCli.debug "stdout: " + openSafariDebug.stdout

module.exports = SafariDebug
