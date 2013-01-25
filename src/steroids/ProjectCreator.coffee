steroids = require "../steroids"
wrench = require "wrench"
path = require "path"

class ProjectCreator

  constructor: ->

  clone: (targetDirectory, template = "default") ->

    unless targetDirectory
      return steroids.Help.usage();

    wrench.copyDirSyncRecursive path.join(steroids.paths.applicationTemplates, template), targetDirectory

module.exports = ProjectCreator
