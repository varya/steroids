Server = require "./Server"
WebServer = require "./servers/WebServer"
util = require "util"
open = require "open"

URL = require "url"

class Serve
  constructor: (@port) ->
    @baseURL = "http://localhost:#{@port}/"

  start: =>
    config = steroidsCli.config.getCurrent()

    startLocation = if config.tabBar and config.getCurrent().tabBar.enabled
      config.tabBar.tabs[0].location
    else
      config.location

    startLocationURL = URL.parse(startLocation)

    # add ripple ui enabler parameter
    url = URL.parse(@baseURL + startLocationURL.path)
    url.query = {} unless url.query?
    url.query["enableripple"] = "cordova"
    url = URL.format(url)

    serveServer = Server.start
      port: @port
      callback: ()=>
        webServer = new WebServer
          path: "/"

        serveServer.mount(webServer)

        util.log "Serving application in #{url}"

        open url

module.exports = Serve
