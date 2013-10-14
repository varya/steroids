paths = require "./paths"
path = require "path"
sbawn = require("./sbawn")

Help = require "./Help"

os = require "os"

class SafariDebug

  listViews: =>
    unless os.type() == "Darwin"
      console.log "Error: Safari Developer Tools debugging requires Mac OS X."
      return false

    scriptPath = path.join paths.scriptsDir, "SafariDebugWebViewLister.scpt"

    openSafariDebugWebViewLister = sbawn
      cmd: "osascript"
      args: [scriptPath]

    openSafariDebugWebViewLister.on "exit", () =>
      steroidsCli.debug "SafariDebug started and killed."
      steroidsCli.debug "stderr: " + openSafariDebugWebViewLister.stderr
      steroidsCli.debug "stdout: " + openSafariDebugWebViewLister.stdout

      console.log "\n\n  Found following WebViews in Safari:\n"
      for line in openSafariDebugWebViewLister.stdout.split("\n") when line isnt ""
        console.log "   - #{line}"

      console.log ""

  open: (argument)=>
    unless os.type() == "Darwin"
      console.log "Error: Safari Developer Tools debugging requires Mac OS X."
      return false

    scriptPath = path.join paths.scriptsDir, "openSafariDevMenu.scpt"

    openSafariDebug = sbawn
      cmd: "osascript"
      args: [scriptPath, argument]

    openSafariDebug.on "exit", () =>
      steroidsCli.debug "SafariDebug started and killed."
      steroidsCli.debug "stderr: " + openSafariDebug.stderr
      steroidsCli.debug "stdout: " + openSafariDebug.stdout

module.exports = SafariDebug
