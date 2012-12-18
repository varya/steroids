Paths = require "../src/steroids/paths"
wrench = require "wrench"
path = require "path"
fs = require "fs"
spawn = require("child_process").spawn
request = require "request"

describe 'Packager', ->

  beforeEach ->

    fs.unlinkSync Paths.temporaryZip if fs.existsSync Paths.temporaryZip

    # create test directory where we can play around

    @testWorkingDirectory = path.join process.cwd(), "__test"

    wrench.rmdirSyncRecursive @testWorkingDirectory, true

    fs.mkdirSync @testWorkingDirectory

    process.chdir @testWorkingDirectory

    # create project
    runs ()=>
      # create new app
      create = spawn("..#{path.sep}bin#{path.sep}steroids", ["create", "testApp"], [{cwd: @testWorkingDirectory}])

      create.on "exit", ()=>
        @testAppDirectory = path.join(@testWorkingDirectory, "testApp")

    waitsFor(()=>
      return @testAppDirectory
    , "Test App Directory should be created", 2000)

    # build it

    runs ()=>

      binaryPath = path.join process.cwd(), "..", "bin", "steroids"

      process.chdir @testAppDirectory

      make = spawn(binaryPath, ["make"], [{cwd: @testAppDirectory}])
      #make.stdout.on "data", (data)-> console.log "#{data.toString()}"
      #make.stderr.on "data", (data)-> console.log "#{data.toString()}"

      make.on "exit", ()=>
        @makeRun = true

    waitsFor(()=>

      return @makeRun

    , 'Grunt file exists', 5000)

  afterEach ->

    # clean up
    fs.unlinkSync Paths.temporaryZip if fs.existsSync Paths.temporaryZip

    process.chdir path.join __dirname, ".."

    wrench.rmdirSyncRecursive @testWorkingDirectory, false


  describe 'zip', ->

    it 'should be created', ->
      packaged = false
      # run build
      runs ()=>
        packageProcess = spawn("..#{path.sep}..#{path.sep}bin#{path.sep}steroids", ["package"], [{cwd: @testWorkingDirectory}])


        packageProcess.on "exit", ()->
          packaged = true

      waitsFor(()->

        return packaged

      , "Command 'package' should complete", 10000)

      runs ()=>
        expect(fs.existsSync Paths.temporaryZip).toBe true