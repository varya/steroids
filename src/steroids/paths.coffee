path = require "path"
pathExtra = require "path-extra"

pathExtra.tempdir()

class Paths

  @npm: path.join __dirname, "..", ".."

  @templatesDir: path.join @npm, "templates"
  @templates:
    applications: path.join @templatesDir, "applications"
    resources: path.join @templatesDir, "resources"
    scaffolds: path.join @templatesDir, "scaffolds"

  @includedGrunt: path.join @npm, "node_modules", "grunt", "lib", "grunt"

  @staticFiles: path.join @npm, "public"
  @oauthSuccessHTML: path.join @staticFiles, "oauth2_success.html"

  @bannersDir: path.join @npm, "support"
  @banners:
    logo: path.join @bannersDir, "logo"
    usage: path.join @bannersDir, "usage"
    welcome: path.join @bannersDir, "welcome"
    legacy:
      requiresDetected: path.join @bannersDir, "legacy-requiresdetected"
      capitalizationDetected: path.join @bannersDir, "legacy-capitalizationdetected"

  @application: process.cwd()
  @appConfigCoffee: path.join @application, "config", "application.coffee"
  @cloudConfigJSON: path.join @application, "config", "cloud.json"
  @dist: path.join @application, "dist"

  @temporaryZip: path.join pathExtra.tempdir(), "steroids_project.zip"

  @userHome: if process.platform == 'win32' then process.env.USERPROFILE else process.env.HOME
  @storedSettings:path.join @userHome, ".appgyver"
  @oauthTokenPath: path.join @storedSettings, "token.json"

module.exports = Paths
