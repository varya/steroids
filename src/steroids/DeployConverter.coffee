fs = require "fs"

Paths = require "./paths"
Config = require "./config"

class DeployConverter
  constructor: (@configPath)->
    delete require.cache[@configPath] if require.cache[@configPath]

    global.steroids =
      config: new Config

    require @configPath

    @config = global.steroids.config

  applicationCloudSchemaRepresentation: ->
    name: @config.name || "New project"
    framework_id: 13
    navigation_bar_style: @config.theme
    status_bar_style: @statusBarStyle()
    fullscreen: not @config.tabBar.enabled
    fullscreen_start_url: @config.location
    client_version: "edge"
    initial_eval_js_string: ""
    background_eval_js_string: ""
    nav_bar_tint_color: @config.navigationBar.tintColor
    nav_bar_title_text_color: @config.navigationBar.titleColor
    nav_bar_title_shadow_color: @config.navigationBar.titleShadowColor
    nav_bar_button_tint_color: @config.navigationBar.buttonTintColor
    nav_bar_button_title_text_color: @config.navigationBar.buttonTitleColor
    nav_bar_button_title_shadow_color: @config.navigationBar.buttonShadowColor
    tab_bar_tint_color: @config.tabBar.tintColor
    tab_bar_button_title_text_color: @config.tabBar.tabTitleColor
    tab_bar_button_title_shadow_color: @config.tabBar.tabTitleShadowColor
    tab_bar_selected_icon_tint_color: @config.tabBar.selectedTabTintColor
    tab_bar_selected_indicator_background_image: @config.tabBar.selectedTabBackgroundImage
    wait_for_document_ready_before_open: @config.wait_for_document_ready_before_open ? "true"
    open_clicked_links_in_new_layer: @config.open_clicked_links_in_new_layer ? "false"
    shake_gesture_enabled_during_development: @config.shake_gesture_enabled_during_development ? "false"
    tabs: @tabsCloudSchemaRepresentation()

  tabsCloudSchemaRepresentation: ->
    if @config.tabBar?.tabs?
      @config.tabBar.tabs
    else
      []

  statusBarStyle: ->
    unless @config.statusBar?.enabled? && @config.statusBar.enabled == true
      "hidden"
    else
      @config.statusBar.style


module.exports = DeployConverter
