Server = require "./Server"
WebServer = require "./servers/WebServer"
util = require "util"
open = require "open"
paths = require "./paths"

URL = require "url"

class Serve
  constructor: (@port, @opts = {ripple: false}) ->
    if @opts.ripple
      @baseURL = "http://127.0.0.1:#{@opts.ripplePort||4400}/"
    else
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

    serveServer = Server.start
      port: @port
      callback: ()=>
        webServer = new WebServer
          path: "/"

        serveServer.mount(webServer)

        util.log "Serving application in #{url}"

        return if steroidsCli.platform == "tizen"

        if @opts.ripple?
          console.log "Opening Ripple"
          open url, "Google\ Chrome"
        else
          open url

module.exports = Serve
