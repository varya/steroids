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

  uploadToCloud: ()->
    unless Login.authTokenExists()
      execSync "steroids login"

    unless Login.authTokenExists()
      util.log "Canceling cloud build due to login failure"
      return

    execSync "steroids push"

    @client = restify.createJsonClient
      # url: 'https://appgyver-staging.herokuapp.com'
      url: 'https://anka.appgyver.com'

    @client.basicAuth Login.currentAccessToken(), 'X'

    @uploadApplicationJSON ()=>
      @uploadApplicationTabs ()=>
        @uploadApplicationZip ()=>
          @updateConfigurationFile()

  uploadApplicationJSON: (callback)->
    util.log "Updating application configuration"

    @app = @converter.applicationCloudSchemaRepresentation()

    util.log "Uploading #{JSON.stringify(@app)}"

    requestData =
      application: @app

    restifyCallback = (err, req, res, obj)=>
      util.log "RECEIVED SYNC RESPONSE"
      # util.log "err: #{util.inspect(err)}"
      # util.log "req: #{util.inspect(req)}"
      # util.log "res: #{util.inspect(res)}"
      # util.log "obj: #{util.inspect(obj)}"

      unless err
        util.log "RECEIVED APPJSON SYNC SUCCESS"
        @cloudApp = obj
        callback()
      else
        util.log "RECEIVED APPJSON SYNC FAILURE"
        process.exit 1

    if @cloudConfig
      util.log "PUT"
      client.put "/studio_api/applications/#{cloudConfig.application_id}", requestData, restifyCallback
    else
      util.log "POST"
      client.post "/studio_api/applications", requestData, restifyCallback


  uploadApplicationTabs: (callback)->
    util.log("Updating application tabs")

    @tabs = @converter.tabsCloudSchemaRepresentation()

    @updateAndRemoveCloudTabs ()=>
      @createNewLocalTabs ()=>
        callback()

  updateAndRemoveCloudTabs: (callback)->
    @fetchCloudTabs ()=>

    # application_id: app.id
    # position: => @get "position"

    util.log "Uploading #{JSON.stringify(@tabs)}"
    callback()

  fetchCloudTabs: (callback)->
    util.log "fetching cloud tabs"

  uploadApplicationZip: (callback)->
    util.log "Updating application build"
    callback()

  updateConfigurationFile: ()->
    util.log "Updating #{paths.cloudConfigJSON}"

    process.exit 0

module.exports = Deploy
