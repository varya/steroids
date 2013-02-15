fs = require "fs"

Paths = require "./paths"
Config = require "./config"

class Converter
  constructor: (@configPath)->

  configToAnkaFormat: ->
    delete require.cache[@configPath] if require.cache[@configPath]

    global.steroids =
      config: new Config

    require @configPath

    configObject = global.steroids.config

    ankaLikeJSON =
      id: 1
      name: configObject.name||"Default name"

    if fs.existsSync Paths.temporaryZip
      ankaLikeJSON.build_timestamp = fs.lstatSync(Paths.temporaryZip).mtime.getTime()

    ankaLikeJSON.configuration = @configurationObject(configObject)
    ankaLikeJSON.appearance = @appearanceObject(configObject)

    ankaLikeJSON.files = []
    ankaLikeJSON.archives = []

    ankaLikeJSON.bottom_bars = @tabsObject(steroids.config) # TODO: asetappa bottombars

    # legacy stuff
    ankaLikeJSON.authentication = @legacyAuthenticationObject()
    ankaLikeJSON.update = @legacyUpdateObject()

    return ankaLikeJSON

  tabsObject: (config)->
    return [] unless config.tabBar.tabs.length
    return [] if @fullscreen

    tabs = []
    for configTab, i in config.tabBar.tabs
      tab =
        position: i,
        title: configTab.title
        image_path: configTab.icon
        target_url: configTab.location.replace("http://localhost/", "http://localhost:13101/")

      tabs.push tab

    return tabs


  configurationObject: (config)->

    if config.statusBar.enabled == false or config.statusBar.enabled == undefined
      statusBar = "hidden"
    else
      statusBar = config.statusBar.style

    if config.tabBar.enabled == true
      @fullscreen = false
    else
      @fullscreen = true

    @betterFullScreenStartUrl = config.location.replace("http://localhost/", "http://localhost:13101/") if config.location?

    return {
      request_user_location: "false"
      fullscreen: "#{@fullscreen}"
      fullscreen_start_url: "#{@betterFullScreenStartUrl}"
      splashscreen_duration_in_seconds: 0
      client_version: "edge"
      navigation_bar_style: "#{config.theme}"
      status_bar_style: statusBar
      initial_eval_js_string: ""
      background_eval_js_string: ""
      wait_for_document_ready_before_open: "true"
      open_clicked_links_in_new_layer: "false"
      shake_gesture_enabled_during_development: "false"
    }

  appearanceObject: (config)->
    return {
      nav_bar_tint_color: "#{config.navigationBar.tintColor}",
      nav_bar_title_text_color: "#{config.navigationBar.titleColor}",
      nav_bar_title_shadow_color: "#{config.navigationBar.titleShadowColor}",
      nav_bar_button_tint_color: "#{config.navigationBar.buttonTintColor}",
      nav_bar_button_title_text_color: "#{config.navigationBar.buttonTitleColor}",
      nav_bar_button_title_shadow_color: "#{config.navigationBar.buttonShadowColor}",
      tab_bar_tint_color: "#{config.tabBar.tintColor}",
      tab_bar_button_title_text_color: "#{config.tabBar.tabTitleColor}",
      tab_bar_button_title_shadow_color: "#{config.tabBar.tabTitleShadowColor}",
      tab_bar_selected_icon_tint_color: "#{config.tabBar.selectedTabTintColor}",
      tab_bar_selected_indicator_background_image: "#{config.tabBar.selectedTabBackgroundImage}"
    }

  legacyAuthenticationObject: ->
    return {
      title: "Log in recommended"
      link_types: [ ]
      message: "You should login to use Facebook. You can also login later for commenting etc."
      cancel_button_text: "Back"
    }

  legacyUpdateObject: ->
    return {
      minimum_required_version: "2.0",
      update_recommendation_url: "http://store.apple.com/",
      title: "Update found",
      text: "You should update",
      current_version: "2.0"
    }


module.exports = Converter
