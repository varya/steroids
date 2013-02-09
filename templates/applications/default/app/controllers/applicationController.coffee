# always put everything inside PhoneGap deviceready

document.addEventListener "deviceready", ->

  $(".opensLayer").on "tap", ->
    # Create a new webview that ...
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }

    # Open on top of this document and pushes to the navigation stack
    steroids.layers.push layer: webview


  $(".opensModal").on "tap", ->
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }
    steroids.modal.show { layer: webview }


  $(".closesModal").on "tap", ->
    steroids.modal.hide()
