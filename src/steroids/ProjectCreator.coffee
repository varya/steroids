steroids = require "../steroids"
wrench = require "wrench"
path = require "path"
fs = require "fs"

class ProjectCreator

  constructor: ->

  clone: (targetDirectory, template = "default") ->

    unless targetDirectory
      return steroids.Help.usage();

    if (fs.existsSync(targetDirectory))
      console.log "Error: '#{targetDirectory}' already exists"
      process.exit(1)

    wrench.copyDirSyncRecursive path.join(steroids.paths.templates.applications, template), targetDirectory

module.exports = ProjectCreator
