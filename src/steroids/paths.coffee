path = require "path"

class Paths

	@npm: path.join __dirname, "..", ".."
	@templates: path.join @npm, "templates"
	@gruntFileTemplate: path.join @templates, "default", "grunt.js"
	@includedGrunt: path.join @npm, "node_modules", "grunt", "lib", "grunt"


module.exports = Paths