Server = require "../Server"
Converter = require "../Converter"
util = require "util"
path = require "path"

fs = require "fs"
Paths = require "../paths"

class WebServer extends Server

  constructor: (@options) ->
    super(@options)


  setRoutes: =>

    @app.get "*", (req, res) ->

      if req.path == "/"
        filePath = "index.html"
      else
        filePath = req.path

      fileDistPath = path.join("dist", filePath)

      unless fs.existsSync(fileDistPath)
        res.status(status = 404)
      else
        res.status(status = 200).sendfile(fileDistPath)

      util.log "GET -- #{status} -- #{req.path}"



module.exports = WebServer