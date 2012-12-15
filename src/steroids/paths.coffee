path = require "path"

class Paths

  @npm: path.join __dirname, "..", ".."
  @templates: path.join @npm, "templates"
  @gruntFileTemplate: path.join @templates, "default", "grunt.js"
  @includedGrunt: path.join @npm, "node_modules", "grunt", "lib", "grunt"
  @staticFiles: path.join @npm, "public"
  @steroidsJSON: path.join process.cwd(), "config", "steroids.json"

module.exports = Paths