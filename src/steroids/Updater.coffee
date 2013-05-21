Help = require "./Help"
restler = require "restler"
os = require "os"

class Updater


  constructor: ->


  check: =>
    currentVersion = steroidsCli.version.getVersion()

    osType = os.type()
    encodedOsType = encodeURIComponent(osType)
    encodedVersion = encodeURIComponent(currentVersion)

    endpointURL = "http://updates.appgyver.com/steroids/latest.json?os=#{encodedOsType}&version=#{encodedVersion}"

    restler.get(endpointURL).on 'complete', (data) =>
      return if data.errno

      latestVersion = data['latest']

      return if latestVersion == currentVersion

      Help.newVersionAvailable(latestVersion)

module.exports = Updater