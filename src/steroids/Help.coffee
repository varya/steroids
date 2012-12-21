paths = require "./paths"

class Help

	@usage: ->
    @printBanner(paths.usageBanner)

  @welcome: ->
    @printBanner(paths.welcomeBanner)

  @logo: ->
    @printBanner(paths.logoBanner)

  @printBanner: (filename) ->
    fs = require "fs"
    console.log fs.readFileSync(filename).toString()    

module.exports = Help