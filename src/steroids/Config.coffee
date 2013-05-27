paths = require "./paths"

class Config

  constructor: ->
    @editor = {}

    @statusBar =
      style: "black"
      enabled: false

    @navigationBar =
      tintColor:                  ""
      titleColor:                 ""
      titleShadowColor:           ""

      buttonTitleColor:           ""
      buttonShadowColor:          ""
      buttonTintColor:            ""

    @theme = "black"

    @location = "http://localhost/index.html"

    @hosts = []
    @tabBar =
      enabled:                    false
      tintColor:                  ""
      tabTitleColor:              ""
      tabTitleShadowColor:        ""
      selectedTabTintColor:       ""
      selectedTabBackgroundImage: ""
      tabs: []

    @worker =  {}   # what is this?

  getCurrent: () ->
    # needs to use global, because application.coffee needs to stay require free

    configPath = paths.application.configs.application
    delete require.cache[configPath] if require.cache[configPath]

    global.steroids =
      config: new Config

    require configPath

    return global.steroids.config

module.exports = Config
