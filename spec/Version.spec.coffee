#wrench = require "wrench"
#fs = require "fs"
path = require "path"

TestHelper = require "./TestHelper"
CommandRunner = require "./CommandRunner"


AFTER_VERSION_BUMB = "0.5.2" # <--- intentionally hardcoded!
describe 'Version', ->

  it "represents the version in package.json", ->
    Steroids = require "../src/steroids"
    packageJSON = require "../package.json"

    expect( Steroids.version ).toBe(packageJSON.version)


  describe 'command line', ->

    it 'prints version with --version', ->

      @versionRun = new CommandRunner
        cmd: TestHelper.steroidsBinPath
        args: ["--version"]

      runs ()=>
        @versionRun.run()

      runs ()=>
        expect( @versionRun.stdout ).toBe("AppGyver Steroids #{AFTER_VERSION_BUMB}\n")

    it 'prints version with version', ->

      @versionRun = new CommandRunner
        cmd: TestHelper.steroidsBinPath
        args: ["version"]

      runs ()=>
        @versionRun.run()

      runs ()=>
        expect( @versionRun.stdout ).toBe("AppGyver Steroids #{AFTER_VERSION_BUMB}\n")

