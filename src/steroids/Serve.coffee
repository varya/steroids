Server = require "./Server"
WebServer = require "./servers/WebServer"
util = require "util"
open = require "open"

class Serve
  constructor: (@port) ->


  start: =>
    url = "http://localhost:#{@port}"

    serveServer = Server.start
      port: @port
      callback: ()=>
        webServer = new WebServer
          path: "/"

        serveServer.mount(webServer)

        util.log "Serving application in #{url}"

        open url

module.exports = Serve
