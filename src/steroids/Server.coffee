paths = require "./paths"
util = require "util"


class Server

  constructor: (@options) ->
    express = require "express"

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

  listen: () =>
    throw "port must be set in constructor options before calling listen" unless @options.port

    @app.listen(@options.port)

    util.log "Server started on port #{@options.port}"


  mount: (appToMount) =>
    appToMount.setRoutes()
    @app.use appToMount.options.path, appToMount.app

  interfaces: =>
    os = require 'os'

    interfaces = os.networkInterfaces()
    addresses = []
    for k of interfaces
      if k.indexOf("en") == 0
        for k2 of interfaces[k]
          address = interfaces[k][k2]
          if address.family == 'IPv4' && !address.internal
            addresses.push { ip: address.address, name: k }

    return addresses


  ipAddresses: =>
    @interfaces().map((e) -> return e.ip )

module.exports = Server
