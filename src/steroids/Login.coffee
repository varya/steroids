path = require "path"
util = require "util"
fs = require "fs"
OAuth2 = require('oauth').OAuth2

paths = require "./paths"

class Login
  settings:
    clientId:      "3ceba0084a474f1502c20ef05e0489546a1f89c1b5fb0e7e6666e720c7977c96"
    clientSecret:  "f635ef74e2c759134f968d801a35e075f8a9c250292f1793e22141827d327777"
    baseUrl:       "https://accounts.appgyver.com"
    authPath:      "/auth/appgyver_id/authorize"
    tokenPath:     "/auth/appgyver_id/access_token"
    userPath:      "/auth/appgyver_id/user.json"
    responseType:  "code"

  @authTokenExists: ()->
    fs.existsSync paths.oauthTokenPath

  @removeAuthToken: ()->
    if @authTokenExists
      fs.unlinkSync paths.oauthTokenPath

  @currentAccessToken: ()->
    tokenJSON = fs.readFileSync paths.oauthTokenPath, 'utf8'
    token = JSON.parse tokenJSON

    return token.access_token

  constructor: (@options={})->
    @oauth = new OAuth2(
      @settings.clientId, @settings.clientSecret,
      @settings.baseUrl,
      @settings.authPath,
      @settings.tokenPath)

  authorize: ()->
    @startServer()

    redirectUrl = "http://localhost:#{@options.port}/__appgyver/login/callback"
    authUrl = "#{@settings.baseUrl}#{@settings.authPath}?response_type=#{@settings.responseType}&client_id=#{@settings.clientId}&redirect_uri=#{encodeURIComponent(redirectUrl)}"

    open = require("open")
    open(authUrl)

  startServer: ()->
    LoginServer = require "./servers/LoginServer"
    @server = new LoginServer
      path: "/"
      loginHandler: this

    @options.server.mount(@server)

  consumeAuthorizationCode: (authCode) =>
    @oauth.getOAuthAccessToken(authCode, {}, @consumeAccessToken)

  consumeAccessToken: (somethingNull, accessToken, refreshToken, options) =>
    options.access_token = accessToken
    options.refresh_token = refreshToken
    options.received_at = Math.round(new Date().getTime() / 1000)

    if not fs.existsSync path.dirname(paths.oauthTokenPath)
      fs.mkdirSync path.dirname(paths.oauthTokenPath)

    fs.writeFileSync paths.oauthTokenPath, JSON.stringify(options)

    util.log "Login process successful."
    process.exit 0

module.exports = Login
