Paths = require "../src/steroids/paths"

wrench = require "wrench"
path = require "path"
fs = require "fs"

TestHelper = require "./TestHelper"

describe 'Generator', ->

  beforeEach ->
    @testHelper = new TestHelper

    @testHelper.bootstrap()
    @testHelper.changeToWorkingDirectory()

  afterEach ->
    @testHelper.cleanUp()


  describe 'scaffold', ->

    it 'should be created', ->
      @testHelper.createProjectSync()

      cmd = @testHelper.runInProjectSync "generate",
        args: ["scaffold", "cars"]

      runs ()=>
        expect( cmd.code ).toBe(0)

        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "controllers", "scaffoldController.coffee")).toBe true
        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "scaffold", "index.html")).toBe true
        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "scaffold", "show.html")).toBe true
