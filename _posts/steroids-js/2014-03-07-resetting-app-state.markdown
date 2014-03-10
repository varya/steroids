---
layout: post
title:  "Resetting app state"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS
---

This guide will include tips and tricks to reset various parts of your app state, e.g. after logout or as a response to some other user interaction

## Resetting navigation layer stack back to root view

Currently, there are two ways to programmatically return to the root WebView from the depths of your application.

The first option works on both iOS and Android: simply call [`steroids.layers.popAll()`](http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_Steroids.layers_layers.popAll.md.html#steroids.layers.popAll) and all layers in the stack (except for the root view) will be popped from the stack. The downside is that there's a [known issue](https://github.com/AppGyver/scanner/issues/155) where `popAll()` only works when calling it from a visible tab.

The other option (iOS-only) is to use [`steroids.layers.replace`](http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_Steroids.layers_layers.replace.md.html#steroids.layers.replace), targeting the root WebView of the layer stack.

The root WebView of your app (or root WebView of each tab, if using tabs) is always "preloaded", meaning it has a preload ID available on the native side (see the [Using preloaded WebViews guide](http://guides.appgyver.com/steroids/guides/steroids-js/using-preloaded-webviews/) for more information on preloading and preload IDs). The preload IDs are as follows:

 * **Not using tabs**: the root WebView's preload ID matches the `config.steroids.location` property in `config/application.coffee`
 * **Using tabs**: each tab's root WebView's preload ID matchs the tab object's `location` property in `config/application.coffee`

So, if the `location` property for your tab (or whole app) was `index.html`, you can reset the layer stack by calling `steroids.layers.replace` as follows:

{% highlight javascript %}
var rootView = steroids.views.WebView(
  {
    location: "index.html",
    id: "index.html"
  }
);
steroids.layers.replace(rootView)
{% endhighlight %}
