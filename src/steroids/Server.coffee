paths = require "./paths"
util = require "util"
express = require "express"
http = require 'http'

class Server

  constructor: (@options) ->
    throw "path must be specified" unless @options.path

    @app = express()

    @app.use express.static(paths.staticFiles)

    @port = @options.port

  port: undefined

  setRoutes: () =>
    console.log "Server setRoutes"

    @app.get "*", (req, res) ->
      util.log "No route for path: #{req.path}"
      res.send 404

  listen: (callback=->) =>
    throw "port must be set in constructor options before calling listen" unless @options.port

    @server = http.createServer(@app)
    @server.on "listening", callback
    @server.on "error", @options.errorCallback
    @server.listen @options.port

  mount: (appToMount) =>
    appToMount.setRoutes()
    @app.use appToMount.options.path, appToMount.app

  interfaces: =>
    os = require 'os'

    interfaces = os.networkInterfaces()
    addresses = []
    for k of interfaces
      unless k.indexOf("lo") == 0     # everything else but localhost is okay for the device to connect
        for k2 of interfaces[k]
          address = interfaces[k][k2]
          if address.family == 'IPv4' && !address.internal
            addresses.push { ip: address.address, name: k }

    return addresses


  ipAddresses: =>
    @interfaces().map((e) -> return e.ip )

module.exports = Server
