paths = require "./paths"
colorize = require "colorize"


class Help

	@usage: ->
    @printBanner(paths.usageBanner)

  @welcome: ->
    @printBanner(paths.welcomeBanner, true)

  @logo: ->
    @printBanner(paths.logoBanner, true)

  @legacyDetected: ->
    @printBanner(paths.legacyApplicationCoffeeBanner, true)

  @readContentsSync: (filename) ->
    fs = require "fs"
    return fs.readFileSync(filename).toString()

  @printBanner: (filename, color=false) ->

    contents = @readContentsSync(filename)

    if color
      colorize.console.log  contents
    else
      console.log contents



module.exports = Help