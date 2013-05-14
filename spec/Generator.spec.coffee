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


  describe 'usage', ->
    beforeEach ->
      @testHelper.createProjectSync()

    it "prints usage instructions when no parameters", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: []

      runs =>
        expect( cmd.stdout ).toMatch(/Usage: steroids generate resource/)

    it "gives friendly error message when generator is not found", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: ["neverGonnaExistGenerator"]

      runs =>
        expect( cmd.code ).toBe(1)
        expect( cmd.stderr ).toEqual ""
        expect( cmd.stdout ).toMatch(/No such generator: neverGonnaExistGenerator/)


  describe "resource", ->
    it "creates a resource", ->
      @testHelper.createProjectSync()

      cmd = @testHelper.runInProjectSync "generate",
        args: ["resource", "cars"]

      runs ()=>
        expect( cmd.code ).toBe(0)

        ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "cars.js")
        expect(fs.existsSync ctrlPath).toBe true
        expect(fs.readFileSync(ctrlPath).toString()).toMatch(/window.CarsController/)

        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "cars", "index.html")).toBe true


    it "fails when trying to overwrite existing files", ->
      @testHelper.createProjectSync()

      cmd1 = @testHelper.runInProjectSync "generate",
        args: ["resource", "cars"]

      cmd2 = @testHelper.runInProjectSync "generate",
        args: ["resource", "cars"]

      runs ()=>
        expect( cmd1.code ).toBe(0)
        expect( cmd2.code ).toBe(1)

        ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "cars.js")
        expect(fs.existsSync ctrlPath).toBe true

        expect(cmd2.stdout).toMatch(/would be overwritten by this command/)
