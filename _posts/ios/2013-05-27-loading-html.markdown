---
layout: post
title:  "Using loading.html"
date:   2013-05-27 13:51:34
categories: ios
platforms: iOS
---

### Related Guides
* [Using loading.png (for Android)][loading-png]

### Related API Docs
* [steroids.views.WebView][views-webview-api]
* [steroids.layers.push][layers-push-api]

When a new `steroids.views.WebView` is pushed to the layer stack with `steroids.layers.push`, the push animation starts instantly. However, since the new WebView won't be instantly available, Steroids first shows a special loading screen. After the new WebView fires the `DOMContentLoaded` event, the loading screen smoothly fades away and reveals the WebView underneath.

On iOS, the loading screen is a `steroids.views.WebView` that always shows the `www/loading.html` document. It is loaded into memory at app start, so it is always instantly available. You can modify and style `loading.html` like any other HTML document. It stays in the memory and alive in the background, continuing to execute JavaScript, animate CSS etc.

To disble the loading screen, simply remove the `loading.html` file. Note that without the file, the push animation for a new `WebView` will start only after the `DOMContentLoaded` event has fired, which can lead to noticable unresponsiveness.

## Displaying loading.html programmatically

You can display the `loading.html` programmatically, with the API call:

{% highlight javascript %}
steroids.view.displayLoading();
{% endhighlight %}

Note that you need to programmatically trigger `steroids.view.removeLoading()` after this – there's no other way to dismiss the `loading.html` screen.

## Removing loading.html programmatically

If you call `steroids.layers.push` or `steroids.modal.show` with the options object parameter `keepLoading: true`, the loading screen will not be removed automatically. Rather, you need to call

{% highlight javascript %}
steroids.view.removeLoading();
{% endhighlight %}

which removes the loading screen. This can be useful if you need to e.g. load some data via AJAX before you show the page to the user.

[layers-push-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.layers_layers.push.md.html#steroids.layers.push
[loading-png]: /steroids/guides/android/loading-png/
[views-webview-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.views_views.WebView.md.html#steroids.views.WebView