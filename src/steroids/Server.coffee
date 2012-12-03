
class Server

  constructor: (@options) ->
    express = require "express"

    @app = express()


  listen: () =>
    throw "port must be set in constructor options before calling listen" unless @options.port

    @app.listen(@options.port)

    console.log "Server started on port #{@options.port}"


  mount: (appToMount) =>    
    @app.use appToMount.path, appToMount.app


module.exports = Server

