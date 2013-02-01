fs = require "fs"
path = require "path"
util = require "util"
execSync = require "exec-sync"
restify = require "restify"
async = require "async"

paths = require "./paths"
DeployConverter = require "./DeployConverter"
Login = require("./Login")

class Deploy
  constructor: (@options={})->
    @cloudConfig = JSON.parse(fs.readFileSync(paths.cloudConfigJSON, "utf8")) if fs.existsSync paths.cloudConfigJSON

    @converter = new DeployConverter paths.appConfigCoffee

    @client = restify.createJsonClient
      # url: 'https://appgyver-staging.herokuapp.com'
      url: 'https://anka.appgyver.com'

  uploadToCloud: ()->
    unless Login.authTokenExists()
      execSync "steroids login"

    unless Login.authTokenExists()
      util.log "ERROR: Canceling cloud build due to login failure"
      return

    @client.basicAuth Login.currentAccessToken(), 'X'

    execSync "steroids push"

    @uploadApplicationJSON ()=>
      @uploadApplicationTabs ()=>
        @uploadApplicationZip ()=>
          @updateConfigurationFile()

  uploadApplicationJSON: (callback)->
    # util.log "Updating application configuration"

    @app = @converter.applicationCloudSchemaRepresentation()

    # util.log "Uploading #{JSON.stringify(@app)}"

    requestData =
      application: @app

    restifyCallback = (err, req, res, obj)=>
      # util.log "RECEIVED APPJSON SYNC RESPONSE"
      # util.log "err: #{util.inspect(err)}"
      # util.log "req: #{util.inspect(req)}"
      # util.log "res: #{util.inspect(res)}"
      # util.log "obj: #{util.inspect(obj)}"

      unless err
        # util.log "RECEIVED APPJSON SYNC SUCCESS"
        @cloudApp = obj
        callback()
      else
        # util.log "RECEIVED APPJSON SYNC FAILURE"
        process.exit 1

    if @cloudConfig
      # util.log "PUT"
      @client.put "/studio_api/applications/#{cloudConfig.application_id}", requestData, restifyCallback
    else
      # util.log "POST"
      @client.post "/studio_api/applications", requestData, restifyCallback


  uploadApplicationTabs: (callback)->
    util.log "Updating application tabs"

    @tabs = @converter.tabsCloudSchemaRepresentation()

    @fetchCloudTabs ()=>
      @updateAndRemoveCloudTabs ()=>
        @createNewLocalTabs ()=>
          callback()

  updateAndRemoveCloudTabs: (callback)->
    util.log "Updating and removing cloud tabs"
    # application_id: app.id
    # position: => @get "position"

    callback()

  fetchCloudTabs: (callback)->
    util.log "Fetching cloud tabs"

    restifyCallback = (err, req, req, obj)=>
      # util.log "RECEIVED TABS GET RESPONSE"
      # util.log "err: #{util.inspect(err)}"
      # util.log "req: #{util.inspect(req)}"
      # util.log "res: #{util.inspect(res)}"
      # util.log "obj: #{util.inspect(obj)}"

      unless err
        # util.log "RECEIVED TABS GET SUCCESS"
        @cloudTabs = obj
        callback()
      else
        # util.log "RECEIVED TABS GET FAILURE"
        process.exit 1

    @client.get "/studio_api/bottom_bars?application_id=#{@cloudApp.id}", restifyCallback

  uploadApplicationZip: (callback)->
    util.log "Updating application build"
    callback()

  updateConfigurationFile: ()->
    util.log "Updating #{paths.cloudConfigJSON}"

    process.exit 0

module.exports = Deploy
