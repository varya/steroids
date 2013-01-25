
wrench = require "wrench"
path = require "path"
fs = require "fs"
spawn = require("child_process").spawn

TestHelper = require("./TestHelper")

describe 'ProjectBuilder', ->

  beforeEach ->
    @testHelper = new TestHelper

    @testHelper.bootstrap()
    @testHelper.changeToWorkingDirectory()

  afterEach ->
    @testHelper.cleanUp()



  describe 'make', ->

    beforeEach ->
      @testHelper.createProjectSync()


    it 'should create grunt.js if missing', ->

      pathToGruntFile = path.join @testHelper.testAppPath, "grunt.js"

      fs.unlinkSync pathToGruntFile
      expect( fs.existsSync(pathToGruntFile) ).toBe(false)

      @testHelper.runMakeInProjectSync()

      runs ()=>
        expect( fs.existsSync(pathToGruntFile) ).toBe(true)


    it 'should create dist/ if missing', ->

      pathToDist = path.join @testHelper.testAppPath, "dist"
      wrench.rmdirSyncRecursive pathToDist, true

      expect( fs.existsSync(pathToDist) ).toBe(false)

      @testHelper.runMakeInProjectSync()

      runs ()=>
        expect( fs.existsSync(pathToDist) ).toBe(true)

