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

      if /\/$/.test(req.path)
        filePath = path.join(req.path.substring(1), "index.html")
      else
        filePath = req.path

      fileDistPath = path.join("dist", filePath)

      unless fs.existsSync(fileDistPath)
        res.status(status = 404)
        res.end()
      else
        res.status(status = 200).sendfile(fileDistPath)

      util.log "GET -- #{status} -- #{fileDistPath}"



module.exports = WebServer