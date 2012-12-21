paths = require "./paths"

colorize = require "colorize"
cconsole = colorize.console

class Help

	@usage: ->
    @printBanner(paths.usageBanner)

  @welcome: ->
    @printBanner(paths.welcomeBanner)

  @logo: ->
    @printBanner(paths.logoBanner)

  @printBanner: (filename) ->
    fs = require "fs"
    cconsole.log fs.readFileSync(filename).toString()    

module.exports = Help