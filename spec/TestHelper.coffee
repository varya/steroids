wrench = require "wrench"
fs = require "fs"
path = require "path"

CommandRunner = require "./CommandRunner"

class TestHelper

  @steroidsBinPath: path.join __dirname, "..", "bin", "steroids"

  constructor: (@options = {}) ->
    testDirectory = @options.relativePath || "__test"
    @testAppName = @options.testAppName || "testApp"
    @workingDirectory = path.join process.cwd(), testDirectory
    @testAppPath = path.join(@workingDirectory, @testAppName)

  bootstrap: () =>
    wrench.rmdirSyncRecursive @workingDirectory, true
    fs.mkdirSync @workingDirectory

  changeToWorkingDirectory: () =>
    process.chdir @workingDirectory

  cleanUp: () =>
    if process.cwd() == @workingDirectory
      process.chdir path.join process.cwd(), ".."

    wrench.rmdirSyncRecursive @workingDirectory, false


  createProjectSync: () =>

    @createRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["create", @testAppName]
      timeout: 4000

    runs ()=>
      @createRun.run()

    runs ()=>
      expect( @createRun.code ).toBe(0)



  runMakeInProjectSync: () =>
    @makeRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["make"]
      cwd: @testAppPath

    runs () =>
      @makeRun.run()

    runs () =>
      expect( @makeRun.code ).toBe(0)

module.exports = TestHelper