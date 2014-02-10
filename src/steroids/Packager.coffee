Zip = require "./fs/zip"
Paths = require "./paths"
fs = require "fs"

class Packager
  constructor: ()->
    @zip = new Zip Paths.application.distDir, Paths.temporaryZip

  create: ->
    try
      fd = fs.openSync(Paths.temporaryZip, "w")
    catch err
      console.log err.message
      console.log "Ensure that #{Paths.temporaryZip} is writable"
      process.exit 1

    @zipDistPath()

  zipDistPath: ->
    @zip.create (timestamp) =>
      @latestZipTimestamp = timestamp

module.exports = Packager