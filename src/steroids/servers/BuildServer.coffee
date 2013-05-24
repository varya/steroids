Server = require "../Server"
Converter = require "../Converter"
util = require "util"
request = require "request"
semver = require "semver"

fs = require "fs"
Paths = require "../paths"

class BuildServer extends Server

  constructor: (@options) ->
    @converter = new Converter Paths.application.configs.application
    @clients = {}

    super(@options)

  setRoutes: =>
    @app.get "/", (req, res) =>
      res.redirect("/__appgyver/index.html")

    @app.get "/appgyver/api/applications/1.json", (req, res) =>

      #TODO joutuu varmaan siivoomaan

      firstGoodVersion = "2.3.3"
      clientVersion = req.query["client_version"]

      clientVersionMatch = req.headers["user-agent"].match(/AppGyverSteroids\/([^\s]+)/)
      clientVersion = clientVersionMatch[1] if clientVersionMatch

      clientVersionGood = semver.satisfies(semver.clean(clientVersion), ">=#{firstGoodVersion}")

      clientIsIOS = req.headers["user-agent"].match("iPhone|iPad|iPod")
      fromBackgroundJS = req.url.match("invisible")
      seenBefore = @clients[req.ip]?

      if clientIsIOS? and not fromBackgroundJS? and not seenBefore and not clientVersionGood
        throw "ERROR: Connecting client is version #{clientVersion}, but atleast #{firstGoodVersion} is required. Update the client from the iOS App Store"
        return

      config = @converter.configToAnkaFormat()

      config.archives.push {url: "#{req.protocol}://#{req.host}:#{@options.port}/appgyver/zips/project.zip"}

      request.get { url: "http://127.0.0.1:#{steroidsCli.debugPort}/target/target-script-min.js#anonymous" }, (err, bettereq, betteres)=>
        unless err
          #TODO detect if debugger is online
          config.configuration.initial_eval_js_string += """
          window.addEventListener("load", function(){
            if (!window.AG_DEBUGGER_INJECTED) {
              e = document.createElement('script');
              e.setAttribute('src','#{req.protocol}://#{req.host}:#{steroidsCli.debugPort}/target/target-script-min.js#anonymous');
              document.getElementsByTagName('body')[0].appendChild(e);
              window.AG_DEBUGGER_INJECTED = true;
            }
          }, false);
          """

        res.json config

    @app.get "/appgyver/zips/project.zip", (req, res)->
      res.sendfile Paths.temporaryZip

    @app.get "/refresh_client?:timestamp", (req, res) =>

      client = if @clients[req.ip]
        @clients[req.ip]
      else
        {
          ipAddress: req.ip
          firstSeen: Date.now()
          userAgent: req.headers["user-agent"]
          new: true
        }

      client.lastSeen = Date.now()
      @clients[req.ip] = client

      timestamp = key for key,val of req.query

      if fs.existsSync Paths.temporaryZip
        filestamp = fs.lstatSync(Paths.temporaryZip).mtime.getTime()
      else
        filestamp = 0

      if parseInt(filestamp,10) > parseInt(timestamp,10)
        res.send "true"
      else
        res.send "false"


module.exports = BuildServer
