
wrench = require "wrench"
path = require "path"
fs = require "fs"
spawn = require("child_process").spawn

TestHelper = require("./TestHelper")

describe 'Grunt', ->

  beforeEach ->
    @testHelper = new TestHelper

    @testHelper.bootstrap()
    @testHelper.changeToWorkingDirectory()

  afterEach ->
    @testHelper.cleanUp()


  describe 'running it', ->

    beforeEach ->
      @testHelper.createProjectSync()

    it 'should create dist/ if missing', ->

      pathToDist = path.join @testHelper.testAppPath, "dist"
      wrench.rmdirSyncRecursive pathToDist, true

      expect( fs.existsSync(pathToDist) ).toBe(false)

      @testHelper.runMakeInProjectSync()

      runs ()=>
        expect( fs.existsSync(pathToDist) ).toBe(true)


  describe 'controller compilation', ->

    beforeEach ->
      @testHelper.createProjectSync()

    it 'warns about missing controller for a resource', ->

      wrench.mkdirSyncRecursive( path.join(@testHelper.testAppPath, "app", "views", "talisker") )
      fs.writeFileSync( path.join(@testHelper.testAppPath, "app", "views", "talisker", "index.html"), "test")

      wrench.mkdirSyncRecursive( path.join(@testHelper.testAppPath, "app", "views", "layouts") )
      fs.writeFileSync( path.join(@testHelper.testAppPath, "app", "views", "layouts", "application.html"), "test")

      cmd = @testHelper.runInProjectSync "make",
        args: []

      runs ->
        expect( cmd.code ).toBe(0)

        expect( cmd.stdout ).toMatch(/no controller for resource 'talisker'/)
        expect( cmd.stdout ).toMatch(/app\/controllers\/talisker.\{js\|coffee\}/)

