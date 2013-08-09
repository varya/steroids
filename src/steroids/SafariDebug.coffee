paths = require "./paths"
path = require "path"
sbawn = require("./sbawn")

class SafariDebug

  listViews: =>
    scriptPath = path.join paths.scriptsDir, "SafariDebugWebViewLister.scpt"

    openSafariDebugWebViewLister = sbawn
      cmd: "osascript"
      args: [scriptPath]

    openSafariDebugWebViewLister.on "exit", () =>
      steroidsCli.debug "SafariDebug started and killed."
      steroidsCli.debug "stderr: " + openSafariDebugWebViewLister.stderr
      steroidsCli.debug "stdout: " + openSafariDebugWebViewLister.stdout
      console.log "\nWebViews:"
      for line in openSafariDebugWebViewLister.stdout.split("\n") when line isnt ""
        console.log "- #{line}"

  open: (argument)=>
    scriptPath = path.join paths.scriptsDir, "openSafariDevMenu.scpt"

    openSafariDebug = sbawn
      cmd: "osascript"
      args: [scriptPath, argument]

    openSafariDebug.on "exit", () =>
      steroidsCli.debug "SafariDebug started and killed."
      steroidsCli.debug "stderr: " + openSafariDebug.stderr
      steroidsCli.debug "stdout: " + openSafariDebug.stdout

module.exports = SafariDebug
