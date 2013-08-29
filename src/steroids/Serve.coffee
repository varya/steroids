Server = require "./Server"
WebServer = require "./servers/WebServer"
util = require "util"
open = require "open"

URL = require "url"

class Serve
  constructor: (@port) ->
    @baseURL = "http://127.0.0.1:#{@port}/"

  start: =>
    config = steroidsCli.config.getCurrent()

    startLocation = if config.tabBar and config.getCurrent().tabBar.enabled
      config.tabBar.tabs[0].location
    else
      config.location

    startLocationURL = URL.parse(startLocation)

    url = @baseURL + startLocationURL.path

    serveServer = Server.start
      port: @port
      callback: ()=>
        webServer = new WebServer
          path: "/"

        serveServer.mount(webServer)

        util.log "Serving application in #{url}"

        open url

module.exports = Serve
