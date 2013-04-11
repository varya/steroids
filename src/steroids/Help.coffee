path = require "path"
paths = require "./paths"
colorize = require "colorize"


class Help

	@usage: ->
    @printBanner(paths.banners.usage)

  @attention: ->
    @printBanner(paths.banners.attention, true)

  @connect: ->
    @printBanner(paths.banners.connect)

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

  @legacy:
    requiresDetected: ->
      Help.printBanner(paths.banners.legacy.requiresDetected, true)

    capitalizationDetected: ->
      Help.printBanner(paths.banners.legacy.capitalizationDetected, true)

    specificSteroidsJSDetected: ->
      Help.printBanner(paths.banners.legacy.specificSteroidsJSDetected, true)


  @resetiOSSim: ->
    @printBanner(paths.banners.resetiOSSim, true)

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