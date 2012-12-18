Steroids = require "../src/steroids"

describe 'Steroids', ->

  beforeEach ->

  describe 'config', ->

    it 'provides config', ->
      Config = require "../src/steroids/Config"
      expect(Steroids.config instanceof Config)