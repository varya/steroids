document.addEventListener "DOMContentLoaded", ->
  opensLayerElements = document.querySelectorAll(".opensLayer")
  opensModalElements = document.querySelectorAll(".opensModal")

  for el in opensLayerElements
    Hammer(el).on "tap", ->
      # Create a new WebView that...
      webview = new steroids.views.WebView { location: @getAttribute("data-location") }

      # ...is pushed to the navigation stack, opening on top of the current document.
      steroids.layers.push { view: webview }

  for el in opensModalElements
    Hammer(el).on "tap", ->
      webview = new steroids.views.WebView { location: @getAttribute("data-location") }
      steroids.modal.show { view: webview }
