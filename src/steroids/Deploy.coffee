fs = require "fs"
path = require "path"
util = require "util"
execSync = require "exec-sync"
restify = require "restify"
restler = require "restler"
async = require "async"

paths = require "./paths"
DeployConverter = require "./DeployConverter"
Login = require "./Login"

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
      process.exit 1

    util.log "Building application locally"
    pushOutput = execSync "steroids push", true

    if pushOutput.stderr != ""
      console.log pushOutput.stderr
      util.log "ERROR: Canceling cloud build due to push failure"
      process.exit 1

    # util.log "steroids push output:"
    console.log pushOutput.stdout

    @client.basicAuth Login.currentAccessToken(), 'X'

    @uploadApplicationJSON ()=>
      @uploadApplicationZip ()=>
        @updateConfigurationFile()

  uploadApplicationJSON: (callback)->
    # util.log "Updating application configuration"
    util.log "Uploading Application to cloud"

    @app = @converter.applicationCloudSchemaRepresentation()

    if fs.existsSync paths.cloudConfigJSON
      # util.log "Application has been deployed before"
      cloudConfig = JSON.parse fs.readFileSync(paths.cloudConfigJSON, 'utf8')
      @app.id = cloudConfig.id
      # util.log "Using cloud ID: #{cloudConfig.id}"

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
        # util.log "err: #{util.inspect(err)}"
        # util.log "obj: #{util.inspect(obj)}"
        process.exit 1

    if @app.id?
      # util.log "PUT"
      @client.put "/studio_api/applications/#{@app.id}", requestData, restifyCallback
    else
      # util.log "POST"
      @client.post "/studio_api/applications", requestData, restifyCallback

  uploadApplicationZip: (callback)->
    sourcePath = paths.temporaryZip
    # util.log "Updating application build from #{sourcePath} to #{@cloudApp.custom_code_zip_upload_url}"
    # util.log "key #{@cloudApp.custom_code_zip_upload_key}"

    params =
      success_action_status: "201"
      utf8: ""
      key: @cloudApp.custom_code_zip_upload_key
      acl: @cloudApp.custom_code_zip_upload_acl
      policy: @cloudApp.custom_code_zip_upload_policy
      signature: @cloudApp.custom_code_zip_upload_signature
      AWSAccessKeyId: @cloudApp.custom_code_zip_upload_access_key
      file: restler.file(
        sourcePath, # source path
        "custom_code.zip", # filename
        fs.statSync(sourcePath).size, # file size
        "binary", # file encoding
        'application/octet-stream') # file content type

    uploadRequest = restler.post @cloudApp.custom_code_zip_upload_url, { multipart: true, data:params }
    uploadRequest.on 'success', ()=>
      # util.log "Updated application build"
      callback()

  updateConfigurationFile: ()->
    # util.log "Updating #{paths.cloudConfigJSON}"

    config =
      id: @cloudApp.id
      identification_hash: @cloudApp.identification_hash

    fs.writeFileSync paths.cloudConfigJSON, JSON.stringify(config)

    util.log "Deployment complete"
    process.exit 0

module.exports = Deploy
