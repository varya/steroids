Help = require "./Help"
restler = require "restler"

class Updater


  constructor: ->


  check: =>
    restler.get('https://registry.npmjs.org/steroids').on 'complete', (data) =>
      return if data.errno

      latestVersion = data['dist-tags'].latest

      return if latestVersion == steroidsCli.version.getVersion()

      Help.newVersionAvailable(latestVersion)

module.exports = Updater