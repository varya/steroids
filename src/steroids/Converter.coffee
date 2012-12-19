Paths = require "./paths"
fs = require "fs"

class Converter
  constructor: (@configPath)->

  configToAnkaFormat: ->
    console.log "CONFIG COFFEE PATH: #{@configPath}"
    delete require.cache[@configPath] if require.cache[@configPath]

    config = require @configPath

    ankaLikeJSON =
      id: 1
      name: config.name||"Default name"

    if fs.existsSync Paths.temporaryZip
      ankaLikeJSON.build_timestamp = fs.lstatSync(Paths.temporaryZip).mtime.getTime()

    ankaLikeJSON.configuration = @configurationObject(config)
    ankaLikeJSON.appearance = @appearanceObject(config)

    ankaLikeJSON.files = []
    ankaLikeJSON.archives = []

    ankaLikeJSON.bottom_bars = @tabsObject(config) # TODO: asetappa bottombars

    # legacy stuff
    ankaLikeJSON.authentication = @legacyAuthenticationObject()
    ankaLikeJSON.update = @legacyUpdateObject()

    return ankaLikeJSON

  tabsObject: (config)->
    return [] unless config.tabBar.tabs.length
    ({position: i, title: tab.title, image_path: tab.icon, target_url: tab.location} for tab, i in config.tabBar.tabs)

  configurationObject: (config)->
    return {
      request_user_location: "false"
      fullscreen: "#{!config.tabBar.enabled}"
      fullscreen_start_url: "#{config.location}"
      splashscreen_duration_in_seconds: 0
      client_version: "edge"
      navigation_bar_style: "#{config.theme}"
      status_bar_style: "#{config.statusBar.style}"
      initial_eval_js_string: ""
      background_eval_js_string: ""
      wait_for_document_ready_before_open: "true"
      open_clicked_links_in_new_layer: "false"
      shake_gesture_enabled_during_development: "true"
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