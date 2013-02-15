# always put everything inside PhoneGap deviceready

document.addEventListener "deviceready", ->

  $(".opensLayer").on "tap", ->
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }
    steroids.layers.push { view: webview }

  $(".opensModal").on "tap", ->
    webview = new steroids.views.WebView { location: @getAttribute("data-location") }
    steroids.modal.show { view: webview }

  $(".closesModal").on "tap", ->
    steroids.modal.hide()
