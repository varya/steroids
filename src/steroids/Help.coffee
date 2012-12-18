
class Help

	@usage: ->
    fs = require "fs"
    paths = require "./paths"
    console.log fs.readFileSync(paths.usage).toString()


module.exports = Help