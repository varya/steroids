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


  describe 'ng-resource', ->

    it 'should be created', ->
      @testHelper.createProjectSync()

      cmd = @testHelper.runInProjectSync "generate",
        args: ["ng-resource", "car"]

      runs ()=>
        expect( cmd.code ).toBe(0)

        ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "carsController.coffee")
        expect(fs.existsSync ctrlPath).toBe true
        expect(fs.readFileSync(ctrlPath).toString()).toMatch(/class window.CarsController/)

        modelPath = path.join(@testHelper.testAppPath, "app", "models", "car.coffee")
        expect(fs.existsSync modelPath).toBe true
        expect(fs.readFileSync(modelPath).toString()).toMatch(/class window.Car/)

        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "cars", "index.html")).toBe true
        expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "cars", "show.html")).toBe true
