Server = require "../Server"
Converter = require "../Converter"
util = require "util"

fs = require "fs"
Paths = require "../paths"

class BuildServer extends Server

  constructor: (@options) ->
    super(@options)


  setRoutes: =>

    @app.get "/appgyver/api/applications/1.json", (req, res) ->

      client =
        userAgent: req.headers["user-agent"]

      util.log "Client connected: #{client.userAgent}"

      json = fs.readFileSync Paths.steroidsJSON, "utf8"

      response = Converter.steroidsToAnkaFormat JSON.parse( json )

      res.json response


    @app.get "/refresh_client", (req, res) ->

      res.send "false"





module.exports = BuildServer