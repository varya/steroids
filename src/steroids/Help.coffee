path = require "path"
paths = require "./paths"
colorize = require "colorize"


class Help

	@usage: ->
    @printBanner(paths.banners.usage)

  @welcome: ->
    @printBanner(paths.banners.welcome, true)

  @logo: ->
    @printBanner(paths.banners.logo, true)

  @listGenerators: ->
    Generators = require "./Generators"

    for name, generator of Generators
      console.log "-------------------------"
      console.log ""
      console.log "#{name}:"
      console.log ""
      console.log "Usage: steroids generate #{name} #{generator.usageParams()}"
      console.log ""
      console.log generator.usage()
      console.log ""

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