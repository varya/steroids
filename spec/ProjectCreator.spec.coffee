wrench = require "wrench"
fs = require "fs"

describe 'ProjectCreator', ->

  beforeEach ->
    ProjectCreator = require "../src/steroids/ProjectCreator"
    @projectCreator = new ProjectCreator
    @projectName = "__tmp_new_project"


  describe 'create', ->

    it 'can clone a default project', ->

      @projectCreator.clone @projectName

      expect( fs.existsSync(@projectName) ).toBe(true)

      wrench.rmdirSyncRecursive @projectName

    it 'can clone a tutorial project', ->
      @projectCreator.clone @projectName, 'tutorial'

      expect( fs.existsSync(@projectName) ).toBe(true)

      wrench.rmdirSyncRecursive @projectName
