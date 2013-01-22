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


  runPackageInProjectSync: () =>
    @packageRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["package"]
      cwd: @testAppPath

    runs () =>
      @packageRun.run()

    runs () =>
      expect( @packageRun.code ).toBe(0)


  runConnect: () =>
    @connectRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["connect"]
      cwd: @testAppPath
      waitsFor: 3000

    runs () =>
      @connectRun.run()

    runs () =>
      @requestServerInterval = setInterval(()=>
        require("request").get 'http://localhost:4567/appgyver/api/applications/1.json', (err, res, body)=>
          if err is null
            @running = true
            clearInterval @requestServerInterval
      , 250)

    waitsFor(()=>
      return @running
    , "Command 'connect' should complete", 6000)

  killConnect: () =>
    @connectRun.kill() if @connectRun

module.exports = TestHelper