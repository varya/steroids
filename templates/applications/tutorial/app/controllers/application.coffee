
document.addEventListener "deviceready", () ->

  $(".opensLayer").on "tap", ->
    # Create a new webview that ...
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }

    # opens on top of this document and pushes to the navigation stack
    steroids.layers.push { view: webview }


  $(".opensModal").on "tap", ->
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }
    steroids.modal.show { view: webview }


  $(".closesModal").on "tap", ->
    steroids.modal.hide()
