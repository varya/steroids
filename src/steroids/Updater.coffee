Help = require "./Help"
restler = require "restler"
os = require "os"

Login = require "./Login"

class Updater


  constructor: (@options={})->


  getFromEndpoint: (endpointURL, onSuccess) ->

    restler.get(endpointURL).on 'complete', (data) =>
      return if data.errno

      latestVersion = data["version"]

      onSuccess(latestVersion)

  getCurrentUserId: () =>
    currentToken = Login.currentToken()
    currentUserId = if currentToken
      currentToken.user_id
    else
      null


  checkClient: (opts={}) =>
    platform = opts.platform
    currentVersion = opts.version
    simulator = opts.simulator
    osVersion = opts.osVersion
    device = opts.device

    encodedPlatform = encodeURIComponent(platform)
    encodedVersion = encodeURIComponent(currentVersion)
    encodedOsVersion = encodeURIComponent(osVersion)
    encodedDevice = encodeURIComponent(device)

    currentUserId = @getCurrentUserId()

    currentVersion = opts.version

    endpointURL = "http://updates.appgyver.com/client/latest.json?platform=#{encodedPlatform}&version=#{encodedVersion}&os_version=#{encodedOsVersion}&device=#{encodedDevice}&simulator=#{simulator}&user_id=#{currentUserId}"

    @getFromEndpoint endpointURL, (latestVersion) =>
      if latestVersion == currentVersion
        return

      Help.newClientVersionAvailable
        currentVersion: currentVersion
        latestVersion: latestVersion
        platform: platform
        simulator: simulator

  check: (opts={})=>

    currentUserId = @getCurrentUserId()

    currentVersion = steroidsCli.version.getVersion()

    osType = os.type()
    encodedOsType = encodeURIComponent(osType)
    encodedVersion = encodeURIComponent(currentVersion)

    endpointURL = "http://updates.appgyver.com/steroids/latest.json?os=#{encodedOsType}&version=#{encodedVersion}&from=#{opts.from}&user_id=#{currentUserId}"

    @getFromEndpoint endpointURL, (latestVersion) =>
      if latestVersion == currentVersion
        console.log "Running latest version of Steroids NPM (#{currentVersion})" if @options.verbose
        return

      Help.newVersionAvailable(latestVersion)


module.exports = Updater