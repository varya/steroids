wrench = require "wrench"
path = require "path"
fs = require "fs"
request = require "request"

TestHelper = require "./TestHelper"
CommandRunner = require "./CommandRunner"

describe 'BuildServer', ->

  beforeEach ->
    @testHelper = new TestHelper

    @testHelper.bootstrap()
    @testHelper.changeToWorkingDirectory()
    @testHelper.createProjectSync()


  afterEach ->
    # clean up
    if @buildProcess?
      @buildProcess.kill('SIGKILL')

    @testHelper.cleanUp()


  it "should start", ->

    @connectRun = new CommandRunner
      cmd: TestHelper.steroidsBinPath
      args: ["connect"]
      cwd: @testHelper.testAppPath
      debug: true
      waitsFor: 3000

    runs () =>
      @connectRun.run()

    runs () =>
      @requestServerInterval = setInterval(()=>
        request.get 'http://localhost:4567/appgyver/api/applications/1.json', (err, res, body)=>
          console.log err
          console.log res
          console.log body
          console.log "---"
          if err is null
            @running = true
            clearInterval @requestServerInterval
      , 250)

    waitsFor(()=>
      return @running
    , "Command 'connect' should complete", 4000)

    json = undefined
    gotResponse = false
    runs () =>
      request.get {url: 'http://localhost:4567/appgyver/api/applications/1.json', json: true}, (err, res, body)=>
        json = body
        gotResponse = true


    waitsFor(()=>
      return gotResponse
    , "Did not get json", 4000)

    runs () ->
      expect( json.configuration.fullscreen ).toEqual "true"

