path = require "path"
paths = require "./paths"
colorize = require "colorize"


class Help

  @usage: ->
    @printBanner(paths.banners.usage, true)

  @deployCompleted: ->
    @printBanner(paths.banners.deployCompleted, true)

  @attention: ->
    @printBanner(paths.banners.attention, true)

  @awesome: ->
    @printBanner(paths.banners.awesome, true)

  @SUCCESS: ->
    @printBanner(paths.banners.SUCCESS, true)

  @connect: ->
    @printBanner(paths.banners.connect, true)

  @welcome: ->
    @printBanner(paths.banners.welcome, true)

  @logo: ->
    @printBanner(paths.banners.logo, true)

  @newVersionAvailable: (version) ->
    @attention()
    @printBanner(paths.banners.newVersionAvailable, true)

  @newClientVersionAvailable: (opts) ->
    @attention()
    @printBanner(paths.banners.newClientVersionAvailable, true)
    console.log """

      You have: #{opts.currentVersion}
      Latest available is: #{opts.latestVersion}
    """

    if opts.platform == "android"
      console.log """

        Please update from Google Play.

      """
    else
      console.log """

        Please update from App Store.

      """


  @loggedOut: ->
    @printBanner(paths.banners.loggedOut, true)

  @loggedIn: ->
    @printBanner(paths.banners.loggedIn, true)
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

    simulatorType: ->
      Help.printBanner(paths.banners.legacy.simulatorType, true)

    serve: ->
      Help.printBanner(paths.banners.legacy.serve, true)
    
  @safariListingHeader: ->
    @printBanner(paths.banners.safariListingHeader, true)

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