document.addEventListener("DOMContentLoaded", function() {

  $(".opensLayer").hammer().on("tap", function() {
    // Create a new webview that ...
    webView = new steroids.views.WebView({ location: this.getAttribute("data-location") });

    // opens on top of this document and is pushed to the navigation stack
    steroids.layers.push({ view: webView });
  });

  $(".opensModal").hammer().on("tap", function() {
    // Create a new webview that ...
    webView = new steroids.views.WebView({ location: this.getAttribute("data-location") });

    // opens on top of this document and is pushed to the navigation stack
    steroids.modal.show({ view: webView });
  });


  $(".closesModal").hammer().on("tap", function() {
    steroids.modal.hide();
  });

});
