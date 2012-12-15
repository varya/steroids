Server = require "../Server"
util = require "util"

class BuildServer extends Server

  constructor: (@options) ->
    super(@options)


  setRoutes: =>

    @app.get "/appgyver/api/applications/1.json", (req, res) ->
      
      client =
        userAgent: req.headers["user-agent"]

      util.log "Client connected: #{client.userAgent}"

      response = {}

      res.send JSON.stringify(response)


    @app.get "/refresh_client", (req, res) ->

      res.send "false"





module.exports = BuildServer