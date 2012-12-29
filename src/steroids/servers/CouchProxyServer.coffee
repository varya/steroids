Server = require "../Server"
util = require "util"
path = require "path"
httpProxy = require "http-proxy"

class CouchProxyServer extends Server

  constructor: (@options) ->

    super(@options)


  setRoutes: =>

    proxy = new httpProxy.RoutingProxy()

    @app.all "*", (req, res) ->

      filePath = req.path

      proxy.proxyRequest req, res,
        host: 'localhost',
        port: 5984

      util.log "DATABASE -- #{req.method} -- #{filePath}"



module.exports = CouchProxyServer