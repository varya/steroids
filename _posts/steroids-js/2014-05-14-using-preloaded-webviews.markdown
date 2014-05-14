---
layout: post
title:  "Preloading WebViews"
date:   2014-05-14 11:31
categories: steroids-js
platforms: iOS, Android
---

Initializing and loading the contents of a new WebView takes a bit of time. In case you know that you are going to be needing a specific WebView later, you can preload it to improve user experience.

## Preloading a WebView

The basic use of `preload()` is rather straightforward. The following code will perform a preload and push a view onto the layer stack once preloading has successfully started, e.g. the preloaded WebView exists in the native side memory:

```javascript
var webView = new steroids.views.WebView({location: "settings.html", id:"settingsView"});
webView.preload({}, {
  onSuccess: function() {
    steroids.layers.push(webView);
  }
});
```

The `preload()` function's success callback is fired when the new WebView has been initialized and its target HTML document starts loading. Note that the success callback doesn't ensure anything about the state of the target HTML document – if you need to know when the HTML document is actually fully loaded into the memory, using `window.postMessage` to broadcast a "This WebView is now ready" message is a good way to do it.

The WebView completes loading in the background and remains active (executing JavaScript, loading content and so forth) – the state doesn't change when it is pushed into the layer stack with `steroids.layers.push(webView)`.

Popping a preloaded WebView object doesn't remove it from memory, so if you push the same WebView object back into the layer stack, it will have continued to run outside the layer stack.

A non-preloaded WebView waits for the `DOMContentLoaded` event before it can be pushed into the layer stack, whereas a preloaded view can be pushed instantly. Using preloaded views gives your app a very snappy and native-like feeling.

## Unloading a preloaded WebView

A preloaded webview can be unloaded. Unloading a WebView removes it from memory. The use of `unload()` is pretty simple, to unload the previously loaded `settingsView`:

```javascript
var settingsView = new steroids.views.WebView({location: "settings.html", 
  id: "settingsView");
settingsView.unload({}, {
  onSuccess: function() {
    alert("View has been unloaded.");
  },
  onFailure: function() {
    alert("Failed to unload.")
  }
});
```

You cannot unload a WebView that is currently in the layer stack.

## Preloading modals

Like with layers, when a modal is preloaded, it uses and retains its own navigation bar, so you can use `window.postMessage` to trigger the modal to run `steroids.view.navigationBar.update` before showing it. However, modals do not show the navigation bar by default, so to have a modal show the navigation bar when it opens, you need to call `steroids.modal.show` with the `navigationBar: true` option.

