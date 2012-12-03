wrench = require "wrench"
path = require "path"
fs = require "fs"
spawn = require("child_process").spawn

describe 'ProjectBuilder', ->


  beforeEach ->

    @testWorkingDirectory = path.join process.cwd(), "__test"

    wrench.rmdirSyncRecursive @testWorkingDirectory, true

    fs.mkdirSync @testWorkingDirectory

    process.chdir @testWorkingDirectory


  afterEach ->

    process.chdir path.join __dirname, ".."

    wrench.rmdirSyncRecursive @testWorkingDirectory, false


  describe 'make()', ->


    it 'should generate grunt.js if not found and create dist', ->
      @testAppDirectory = undefined
      @makeRun = false
      @gruntFileExists = false
      @distFolderExists = false

      runs ()=>
        # create new app
        create = spawn("..#{path.sep}bin#{path.sep}steroids", ["create", "testApp"], [{cwd: @testWorkingDirectory}])
        create.on "exit", ()=>
          @testAppDirectory = path.join(@testWorkingDirectory, "testApp")

      waitsFor(()=>
        return @testAppDirectory
      , "Test App Directory should be created", 2000)


      runs ()=>

        binaryPath = path.join process.cwd(), "..", "bin", "steroids"

        process.chdir @testAppDirectory

        make = spawn(binaryPath, ["make"], [{cwd: @testAppDirectory}])
        make.stdout.on "data", (data)->
          console.log "#{data.toString()}"
        make.stderr.on "data", (data)->
          console.log "#{data.toString()}"

        make.on "exit", ()=>
          @makeRun = true

      waitsFor(()=>
        return @makeRun
      , 'Grunt file exists', 5000)


      runs ()=>
        @gruntFileExists = fs.existsSync path.join @testAppDirectory, "grunt.js"
        @distFolderExists = fs.existsSync path.join @testAppDirectory, "dist"
        expect(@gruntFileExists).toBe true
        expect(@distFolderExists).toBe true






  describe 'make()', ->

    it 'should throw error if grunt.js is missing', ->
      # anon func required for throwing: http://stackoverflow.com/questions/4144686/how-to-write-a-test-which-expects-an-error-to-be-thrown
      expect(()-> @projectBuilder.make()).toThrow()

