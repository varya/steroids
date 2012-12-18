class Installer

  @install: () =>
    s = new Installer
    s.install()

  install: ->

    fs = require "fs"

    banner = (fs.readFileSync("./support/banner")).toString()

    console.log banner

    console.log "installing ..."

    console.log "TODO: Installing in Installer"


module.exports = Installer
