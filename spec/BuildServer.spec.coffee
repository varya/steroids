wrench = require "wrench"
path = require "path"
fs = require "fs"
spawn = require("child_process").spawn
request = require "request"

describe 'BuildServer', ->

  beforeEach ->

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


    # run build
    runs ()=>
      @buildProcess = spawn("..#{path.sep}..#{path.sep}bin#{path.sep}steroids", ["build"], [{cwd: @testWorkingDirectory}])
      @built = false

      @intervalleri = setInterval(()=>
        request.get 'http://localhost:4567', (err, res, body)=>
          if err is null
            @built = true
            clearInterval @intervalleri
      , 250)

    waitsFor(()=>

      return @built

    , "Command 'build' should complete", 10000)


  afterEach ->

    # clean up
    if @buildProcess?
      @buildProcess.kill('SIGKILL')

    process.chdir path.join __dirname, ".."

    wrench.rmdirSyncRecursive @testWorkingDirectory, false



  describe 'server', ->

    it 'serves application.json', ->
      json = undefined
      done = false

      runs ()->
        request.get {url: 'http://localhost:4567/appgyver/api/applications/1.json', json: true}, (err, res, body)=>
          if body?
            json = body
            done = true

      waitsFor(()->
        return done
      , "application.json request to complete", 2000)

      runs ()->
        expect( json.configuration.fullscreen ).toEqual "true"