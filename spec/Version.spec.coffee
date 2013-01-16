#wrench = require "wrench"
#fs = require "fs"
path = require "path"

CommandRunner = require "./CommandRunner"

describe 'Version', ->

  it "represents the version in package.json", ->
    Steroids = require "../src/steroids"
    packageJSON = require "../package.json"

    expect( Steroids.version ).toBe(packageJSON.version)


  describe 'command line', ->

    it 'prints version with --version', ->

      @versionRun = new CommandRunner
        cmd: "bin/steroids"
        args: ["--version"]

      runs ()=>
        @versionRun.run()

      runs ()=>
        expect( @versionRun.stdout ).toBe("AppGyver Steroids 0.2.7\n")  # <--- intentionally hardcoded!


    it 'prints version with version', ->

      @versionRun = new CommandRunner
        cmd: "bin/steroids"
        args: ["version"]

      runs ()=>
        @versionRun.run()

      runs ()=>
        expect( @versionRun.stdout ).toBe("AppGyver Steroids 0.2.7\n")  # <--- intentionally hardcoded!

