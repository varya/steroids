Server = require "../Server"
Converter = require "../Converter"
util = require "util"

fs = require "fs"
Paths = require "../paths"

class BuildServer extends Server

  constructor: (@options) ->
    @converter = new Converter Paths.appConfigCoffee
    super(@options)

  setRoutes: =>
    @app.get "/appgyver/api/applications/1.json", (req, res) =>

      client =
        userAgent: req.headers["user-agent"]

      util.log "Client connected: #{client.userAgent}"

      config = @converter.configToAnkaFormat()

      config.archives.push {url: "#{req.protocol}://#{req.host}:4567/appgyver/zips/project.zip"}

      #TODO detect if debugger is online
      config.configuration.initial_eval_js_string += """
      window.addEventListener("load", function(){
        if (!window.AG_DEBUGGER_INJECTED) {
          e = document.createElement('script');
          e.setAttribute('src','#{req.protocol}://#{req.host}:31173/target/target-script-min.js#anonymous');
          document.getElementsByTagName('body')[0].appendChild(e);
          window.AG_DEBUGGER_INJECTED = true;
        }
      }, false);
      """

      res.json config

    @app.get "/appgyver/zips/project.zip", (req, res)->
      res.sendfile Paths.temporaryZip

    @app.get "/refresh_client", (req, res) ->
      res.send "false"


module.exports = BuildServer
