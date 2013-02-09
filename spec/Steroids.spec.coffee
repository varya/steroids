Steroids = require "../src/steroids"

describe 'Steroids', ->

  beforeEach ->

  describe 'config', ->

    it 'provides config with initial tabs', ->
      Config = require "../src/steroids/Config"
      config = new Config()
      expect(config.tabBar.tabs).toEqual([])
