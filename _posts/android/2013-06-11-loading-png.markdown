---
layout: post
title:  "Using loading.png"
date:   2013-05-27 13:51:34
categories: android
platforms: Android
---

### Related Guides
* [Using loading.html (for iOS)][loading-html-guide] (iOS alternative to loading.png)
* [Steroids preferences in config/application.coffee][application-coffee-guide] (contains the loading screen color property)

### Related API Docs
* [steroids.views.WebView][views-webview-api]
* [steroids.layers.push][layers-push-api]

When a new `steroids.views.WebView` is pushed to the layer stack with `steroids.layers.push`, the push animation starts instantly. However, since the new WebView won't be instantly available, Steroids first shows a special loading screen. After the new WebView fires the `DOMContentLoaded` event, the loading screen smoothly fades away and reveals the WebView underneath.

On Android, the loading screen is a static PNG image that is scaled proportionally until it hits either edges of the screen, and then centered. The remaining space is filled with a solid color, defined in `config/application.coffee`:

{% highlight javascript %}
steroids.config.loadingScreen.tintColor = "#262626"
{% endhighlight %}

You can modify the loading screen by replacing the file at `www/loading.png` with your own file and changing the loading screen color.

Note that without a file at `www/loading.png`, a default loading screen will be shown. Disabling the loading screen altogether is currently unsupported in Android.

## Removing the loading screen manually

If you call `steroids.layers.push` or `steroids.modal.show` with the options object parameter `keepLoading: true`, the loading screen will not be removed automatically. Rather, you need to call

{% highlight javascript %}
steroids.view.removeLoading();
{% endhighlight %}

which removes the loading screen. This can be useful if you need to e.g. load some data via AJAX before you show the page to the user.

[application-coffee-guide]: /steroids/guides/project_configuration/config-application-coffee/
[layers-push-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.layers_layers.push.md.html#steroids.layers.push
[loading-html-guide]: /steroids/guides/ios/loading-html/
[views-webview-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.views_views.WebView.md.html#steroids.views.WebView
