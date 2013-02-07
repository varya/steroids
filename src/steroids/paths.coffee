path = require "path"
pathExtra = require "path-extra"

pathExtra.tempdir()

class Paths

  @npm: path.join __dirname, "..", ".."

  @templates:
    applications: path.join @npm, "templates", "applications"
    resources: path.join @npm, "templates", "resources"
    scaffolds: path.join @npm, "templates", "scaffolds"

  @includedGrunt: path.join @npm, "node_modules", "grunt", "lib", "grunt"

  @staticFiles: path.join @npm, "public"
  @oauthSuccessHTML: path.join @staticFiles, "oauth2_success.html"

  @logoBanner: path.join @npm, "support", "logo"
  @usageBanner: path.join @npm, "support", "usage"
  @welcomeBanner: path.join @npm, "support", "welcome"

  @legacyApplicationCoffeeBanner: path.join @npm, "support", "legacy-applicationcoffee"

  @application: process.cwd()
  @appConfigCoffee: path.join @application, "config", "application.coffee"
  @cloudConfigJSON: path.join @application, "config", "cloud.json"
  @dist: path.join @application, "dist"

  @temporaryZip: path.join pathExtra.tempdir(), "steroids_project.zip"

  @userHome: if process.platform == 'win32' then process.env.USERPROFILE else process.env.HOME
  @storedSettings:path.join @userHome, ".appgyver"
  @oauthTokenPath: path.join @storedSettings, "token.json"

module.exports = Paths
