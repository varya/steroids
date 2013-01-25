path = require "path"
pathExtra = require "path-extra"

pathExtra.tempdir()

class Paths

  @npm: path.join __dirname, "..", ".."
  @templates: path.join @npm, "templates"
  @applicationTemplates: path.join @templates, "applications"
  @includedGrunt: path.join @npm, "node_modules", "grunt", "lib", "grunt"
  @staticFiles: path.join @npm, "public"
  @appPath: path.join process.cwd()
  @appConfigCoffee: path.join @appPath, "config", "application.coffee"
  @temporaryZip: path.join pathExtra.tempdir(), "steroids_project.zip"
  @dist: path.join @appPath, "dist"
  @logoBanner: path.join @npm, "support", "logo"
  @usageBanner: path.join @npm, "support", "usage"
  @welcomeBanner: path.join @npm, "support", "welcome"
  @legacyApplicationCoffeeBanner: path.join @npm, "support", "legacy-applicationcoffee"

module.exports = Paths
