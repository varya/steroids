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

  describe 'tutorials', ->

    beforeEach ->
      @testHelper.createProjectSync()

    it "prints usage instructions when no parameters are given", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: ["tutorial"]

      runs ->
        expect( cmd.stdout ).toMatch(/Error: missing name of the generator, see 'steroids generate' for help./)

    it "gives a friendly error message when tutorial is not found", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: ["tutorial", "neverGonnaExistTutorial"]

      runs ->
        expect( cmd.stdout ).toMatch(/Error: No such tutorial neverGonnaExistTutorial, see 'steroids generate' for help./)



  describe 'examples', ->

    beforeEach ->
      @testHelper.createProjectSync()

    it "prints usage instructions when no parameters are given", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: ["example"]

      runs ->
        expect( cmd.stdout ).toMatch(/Error: missing name of the generator, see 'steroids generate' for help./)

    it "gives a friendly error message when example is not found", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: ["example", "neverGonnaExistExample"]

      runs ->
        expect( cmd.stdout ).toMatch(/Error: No such example neverGonnaExistExample, see 'steroids generate' for help./)



  describe 'usage', ->

    beforeEach ->
      @testHelper.createProjectSync()

    it "prints usage instructions when no parameters", ->

      cmd = @testHelper.runInProjectSync "generate",
        args: []

      runs =>
        expect( cmd.stdout ).toMatch(/Usage: steroids generate resource <resource>/)


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

      runs ->
        @cmd1 = @testHelper.runInProjectSync "generate",
          args: ["resource", "cars"]

      runs ->
        @cmd2 = @testHelper.runInProjectSync "generate",
          args: ["resource", "cars"]

      runs ()=>
        expect( @cmd1.code ).toBe(0)
        expect( @cmd2.code ).toBe(1)

        ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "cars.js")
        expect(fs.existsSync ctrlPath).toBe true

        expect(@cmd2.stdout).toMatch(/would be overwritten by this command/)

    describe "ng-resource", ->

      it "creates a angular resource", ->
        @testHelper.createProjectSync()

        cmd = @testHelper.runInProjectSync "generate",
          args: ["ng-resource", "ngCars"]

        runs ()=>
          expect( cmd.code ).toBe(0)

          ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "ngCars.js")
          expect(fs.existsSync ctrlPath).toBe true
          expect(fs.readFileSync(ctrlPath).toString()).toMatch(/angular\.module\('ngCars/)

          expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "ngCars", "index.html")).toBe true
          expect(fs.existsSync path.join(@testHelper.testAppPath, "app", "views", "ngCars", "_details.html")).toBe true


      it "fails when trying to overwrite existing files", ->
        @testHelper.createProjectSync()

        runs ->
          @cmd1 = @testHelper.runInProjectSync "generate",
            args: ["ng-resource", "ngCars"]

        runs ->
          @cmd2 = @testHelper.runInProjectSync "generate",
            args: ["ng-resource", "ngCars"]

        runs ->
          expect( @cmd1.code ).toBe(0)
          expect( @cmd2.code ).toBe(1)

          ctrlPath = path.join(@testHelper.testAppPath, "app", "controllers", "ngCars.js")
          expect(fs.existsSync ctrlPath).toBe true

          expect(@cmd2.stdout).toMatch(/would be overwritten by this command/)

