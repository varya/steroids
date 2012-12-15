class Converter
  ###
  {
  id: 689,
  name: "appstoreexample",
  authentication: {
  title: "Log in recommended",
  link_types: [ ],
  message: "You should login to use Facebook. You can also login later for commenting etc.",
  cancel_button_text: "Back"
  },
  configuration: {
  request_user_location: "false",
  fullscreen: "false",
  fullscreen_start_url: "default/index.html",
  splashscreen_duration_in_seconds: 0,
  client_version: "edge",
  navigation_bar_style: "default",
  status_bar_style: "default",
  initial_eval_js_string: "",
  background_eval_js_string: " if(typeof window.cloudPreview != "undefined") { window.cloudPreview.poll('689', 'ac9d6685026063f609580c5857777946da668e967b43f822bb0ebd64f655ede3'); }; ",
  wait_for_document_ready_before_open: "",
  open_clicked_links_in_new_layer: "",
  shake_gesture_enabled_during_development: ""
  },
  appearance: {
  nav_bar_tint_color: null,
  nav_bar_title_text_color: null,
  nav_bar_title_shadow_color: null,
  nav_bar_button_tint_color: null,
  nav_bar_button_title_text_color: null,
  nav_bar_button_title_shadow_color: null,
  tab_bar_tint_color: null,
  tab_bar_button_title_text_color: null,
  tab_bar_button_title_shadow_color: null,
  tab_bar_selected_icon_tint_color: null,
  tab_bar_selected_indicator_background_image: null
  },
  update: {
  minimum_required_version: "2.0",
  update_recommendation_url: "http://store.apple.com/",
  title: "Update found",
  text: "You should update",
  current_version: "2.0"
  },
  archives: [
  {
  url: "https://appgyver-anka-uploads-production.s3.amazonaws.com/uploads/framework/zip/12/framework-0.9.1.zip"
  },
  {
  url: "https://appgyver-anka-uploads-production.s3.amazonaws.com/uploads/application/custom_code_zip/689/custom_code.zip"
  }
  ],
  files: [ ],
  bottom_bars: [
  {
  position: -5,
  title: "First tab",
  target_url: "default/index.html",
  image_path: "default/assets/icon.png"
  },
  {
  position: -3,
  title: "Second tab",
  target_url: "default/second_tab.html",
  image_path: "default/assets/icon.png"
  }
  ]
  }

  ###


  @steroidsToAnkaFormat: (json)->

    console.log "JSON IS:"
    console.log json

    ankaFormattedJSON = {
      id: 689,
      name: "appstoreexample",
      authentication: {
        title: "Log in recommended",
        link_types: [ ],
        message: "You should login to use Facebook. You can also login later for commenting etc.",
        cancel_button_text: "Back"
      },
      configuration: {
        request_user_location: "false",
        fullscreen: "#{json.fullscreen}",
        fullscreen_start_url: "#{json.fullscreen_start_url}",
        splashscreen_duration_in_seconds: 0,
        client_version: "#{json.client_version}",
        navigation_bar_style: "#{json.navigation_bar_style}",
        status_bar_style: "#{json.status_bar_style}",
        initial_eval_js_string: "",
        background_eval_js_string: "#{json.background_eval_js_string}",
        wait_for_document_ready_before_open: "true",
        open_clicked_links_in_new_layer: "false",
        shake_gesture_enabled_during_development: "true"
      },
      appearance: {
        nav_bar_tint_color: "#{json.nav_bar_tint_color}",
        nav_bar_title_text_color: "#{json.nav_bar_title_text_color}",
        nav_bar_title_shadow_color: "#{json.nav_bar_title_shadow_color}",
        nav_bar_button_tint_color: "#{json.nav_bar_button_tint_color}",
        nav_bar_button_title_text_color: "#{json.nav_bar_button_title_text_color}",
        nav_bar_button_title_shadow_color: "#{json.nav_bar_button_title_shadow_color}",
        tab_bar_tint_color: "#{json.tab_bar_tint_color}",
        tab_bar_button_title_text_color: "#{json.tab_bar_button_title_text_color}",
        tab_bar_button_title_shadow_color: "#{json.tab_bar_button_title_shadow_color}",
        tab_bar_selected_icon_tint_color: "#{json.tab_bar_selected_icon_tint_color}",
        tab_bar_selected_indicator_background_image: "#{json.tab_bar_selected_indicator_background_image}"
      },
      update: {
        minimum_required_version: "2.0",
        update_recommendation_url: "http://store.apple.com/",
        title: "Update found",
        text: "You should update",
        current_version: "2.0"
      },
      archives: [
        {
          url: "http://localhost:4567/current_project_zip.zip"
        }
      ],
      files: [ ],
      bottom_bars: json.bottom_bars
    }
    return ankaFormattedJSON

module.exports = Converter