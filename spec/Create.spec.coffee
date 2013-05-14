Paths = require "../src/steroids/paths"

TestHelper = require "./TestHelper"
CommandRunner = require "./CommandRunner"


fs = require "fs"
path = require "path"

describe 'Steroids', ->

  beforeEach ->
    @testHelper = new TestHelper

    @testHelper.bootstrap()
    @testHelper.changeToWorkingDirectory()

  afterEach ->
    @testHelper.cleanUp()


  describe 'create', ->

    it "creates project with name myApp", ->
      @createRun = new CommandRunner
        cmd: TestHelper.steroidsBinPath
        args: ["create", "myApp"]

      runs ()=>
        @createRun.run()

      runs ()=>
        expect( @createRun.code ).toBe(0)
        expect( fs.existsSync "myApp" ).toBe true

  describe 'project default files', ->

    beforeEach ->
      @testHelper.createProjectSync()
      @wwwPath = path.join @testHelper.testAppPath, "www"
      @configPath = path.join @testHelper.testAppPath, "config"

    it "has www/index.html with salutation", ->
      indexHTMLPath = path.join @wwwPath, "index.html"

      contents = fs.readFileSync(indexHTMLPath).toString()
      expect( contents ).toMatch(/<h1>Welcome to Steroids/)

    it "has config/application.coffee with config.name", ->
      applicationCoffeePath = path.join @configPath, "application.coffee"

      contents = fs.readFileSync(applicationCoffeePath).toString()
      expect( contents ).toMatch(/steroids.config.name = \"My New Application\"/)

    it "has config/bower.json with dependency to steroids.js", ->
      bowerJsonPath = path.join @configPath, "bower.json"

      contents = fs.readFileSync(bowerJsonPath).toString()
      expect( contents ).toMatch(/\"steroids-js\": \"/)

    it "has www/Cordova.plist with key UIWebViewBounce", ->
      cordovaPlistPath = path.join @wwwPath, "Cordova.plist"

      contents = fs.readFileSync(cordovaPlistPath).toString()
      expect( contents ).toMatch(/<key>UIWebViewBounce/)


  # describe 'create', ->
  #   it "prints usage instructions when no parameters", ->
  #     @testHelper.createProjectSync()
  #
  #     cmd = @testHelper.runInProjectSync "generate",
  #       args: []
  #
  #     runs ()=>
  #       expect( cmd.stdout ).toMatch(/Usage: steroids generate resource/)

