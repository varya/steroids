---
layout: post
title:  "Using loading.html"
date:   2013-05-27 13:51:34
categories: 
---

**Supported platforms: iOS**

When a new `steroids.views.WebView` is pushed to the layer stack with `steroids.layers.push`, the push animation starts instantly. However, since the new WebView won't be instantly available, Steroids first shows a special loading view. After the new WebView fires the `DOMContentLoaded` event, the loading view smoothly fades away and reveals the WebView underneath.

The loading view is a `steroids.views.WebView` that always shows the `www/loading.html` document. It is loaded into memory at app start, so it is always instantly available. You can modify and style `loading.html` like any other HTML document. It stays in the memory and alive in the background, continuing to execute JavaScript, animate CSS etc.

To disble the loading view, simply remove the `loading.html` file. Note that Without the file, the push animation for a new `WebView` will start only after the `DOMContentLoaded` event has fired, which can lead to unresponsiveness.

