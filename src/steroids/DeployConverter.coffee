Paths = require "./paths"
fs = require "fs"

class DeployConverter
  constructor: (@configPath)->
    delete require.cache[@configPath] if require.cache[@configPath]

    require @configPath

  applicationCloudSchemaRepresentation: ->
    name: Steroids.config.name || "New project"
    framework_id: 13
    navigation_bar_style: Steroids.config.theme
    status_bar_style: @statusBarStyle()
    fullscreen: Steroids.config.tabBar.enabled
    fullscreen_start_url: Steroids.config.location
    client_version: "edge"
    initial_eval_js_string: ""
    background_eval_js_string: ""
    nav_bar_tint_color: Steroids.config.navigationBar.tintColor
    nav_bar_title_text_color: Steroids.config.navigationBar.titleColor
    nav_bar_title_shadow_color: Steroids.config.navigationBar.titleShadowColor
    nav_bar_button_tint_color: Steroids.config.navigationBar.buttonTintColor
    nav_bar_button_title_text_color: Steroids.config.navigationBar.buttonTitleColor
    nav_bar_button_title_shadow_color: Steroids.config.navigationBar.buttonShadowColor
    tab_bar_tint_color: Steroids.config.tabBar.tintColor
    tab_bar_button_title_text_color: Steroids.config.tabBar.tabTitleColor
    tab_bar_button_title_shadow_color: Steroids.config.tabBar.tabTitleShadowColor
    tab_bar_selected_icon_tint_color: Steroids.config.tabBar.selectedTabTintColor
    tab_bar_selected_indicator_background_image: Steroids.config.tabBar.selectedTabBackgroundImage
    wait_for_document_ready_before_open: Steroids.config.wait_for_document_ready_before_open ? "true"
    open_clicked_links_in_new_layer: Steroids.config.open_clicked_links_in_new_layer ? "false"
    shake_gesture_enabled_during_development: Steroids.config.shake_gesture_enabled_during_development ? "false"
    tabs: @tabsCloudSchemaRepresentation()

  tabsCloudSchemaRepresentation: ->
    if Steroids.config.tabBar?.tabs?
      Steroids.config.tabBar.tabs
    else
      []

  statusBarStyle: ->
    unless Steroids.config.statusBar?.enabled? && Steroids.config.statusBar.enabled == true
      "hidden"
    else
      Steroids.config.statusBar.style


module.exports = DeployConverter
