steroids = require "../steroids"
wrench = require "wrench"
path = require "path"

class ProjectCreator

	constructor: ->

	clone: (targetDirectory, template = "default") ->

		unless targetDirectory
			return steroids.Help.usage();

		console.log steroids.paths.templates
		
		wrench.copyDirSyncRecursive path.join(steroids.paths.templates, template), targetDirectory

module.exports = ProjectCreator