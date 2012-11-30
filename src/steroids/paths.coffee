path = require "path"

class Paths

	@npm: path.join __dirname, "..", ".."
	@templates: path.join @npm, "templates"


module.exports = Paths