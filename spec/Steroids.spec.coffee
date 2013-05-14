steroids = require "../src/steroids"

describe 'steroids', ->

  beforeEach ->

  describe 'config', ->

    it 'provides config with initial tabs', ->
      Config = require "../src/steroids/Config"
      config = new Config()
      expect(config.tabBar.tabs).toEqual([])
