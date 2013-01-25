paths = require "./paths"
path = require "path"

class Version

  @getVersion: () ->
    packageJSON = require path.join paths.npm, "package.json"
    return packageJSON.version

module.exports = Version