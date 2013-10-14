Server = require "./Server"
WebServer = require "./servers/WebServer"
util = require "util"
open = require "open"
paths = require "./Paths"

URL = require "url"

class Serve
  constructor: (@port, @opts = {ripple: false}) ->
    @baseURL = "http://127.0.0.1:#{@port}/"

  start: =>
    config = steroidsCli.config.getCurrent()

    startLocation = if config.tabBar and config.getCurrent().tabBar.enabled
      config.tabBar.tabs[0].location
    else
      config.location

    startLocationURL = URL.parse(startLocation)

    # add ripple ui enabler parameter
    url = URL.parse(@baseURL + startLocationURL.path)

    # add ripple enabler
    if @opts.ripple
      url.query = {} unless url.query?
      url.query["enableripple"] = "cordova-2.0.0-iPhone5"

    url = URL.format(url)

    # ripple override
    if @opts.ripple
      util.log "Going to check for Ripple UI extension.."
      url = "#{@baseURL}ripple-install-instructions.html?redirect_to=#{encodeURIComponent(url)}"

    serveServer = Server.start
      port: @port
      callback: ()=>
        webServer = new WebServer
          path: "/"

        serveServer.mount(webServer)

        util.log "Serving application in #{url}"

        if @opts.ripple?
          open url, "Google\ Chrome"
        else
          open url

module.exports = Serve
