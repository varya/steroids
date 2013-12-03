---
layout: post
title:  "Using preloaded WebViews"
date:   2013-10-24 11:31
categories: steroids-js
platforms: iOS, Android
---
Initializing and loading the contents of a new WebView takes a bit of time. In case you know that you are going to be needing a specific WebView later, you can preload it to improve user experience.

## Loading a WebView in the background with preload

The use of `preload()` is rather straightforward. The following code will perform a preload and push a view onto the layer stack once preloading has successfully started.

{% highlight javascript %}
var webView = new steroids.view.WebView("view.html");
webView.preload({}, {
  onSuccess: function() {
    steroids.layers.push(webView);
  }
});
{% endhighlight %}

The `preload()` function's success callback is fired when the new WebView has been initialized and its target HTML document starts loading. Note that the success callback doesn't ensure anything about the state of the target HTML document – if you need to know when the HTML document is actually fully loaded into the memory, using `window.postMessage` to broadcast a "This WebView is now ready" message is a good way to do it.

The WebView completes loading in the background and remains active (executing JavaScript, loading content and so forth) – the state doesn't change when it is pushed into the layer stack with `steroids.layers.push(webView)`.

Popping a preloaded WebView object doesn't remove it from memory, so if you push the same WebView object back into the layer stack, it will have continued to run outside the layer stack.

A non-preloaded WebView waits for the DOMContentLoaded event before it can be pushed into the layer stack, whereas a preloaded view can be pushed instantly.

## Preload only happens once per WebView

You may have multiple entry points to a single WebView in an application. However, you can only preload a WebView once. In case you have many WebView objects pointing to the same identical URL, only the first preload is successful, and additional ones trigger a failure callback.

If you are interested in only whether a preloaded WebView is ready for use and not in whether this specific preload was successful, you will have to detect the case where the WebView was already preloaded.

## Unloading a preloaded WebView

A preloaded webview can be unloaded. Contrary to `steroids.layers.pop()`, unloading a WebView removes it from memory. The use of `unload()` is pretty simple:

{% highlight javascript %}
var webView = new steroids.view.WebView("view.html");
webView.unload({}, {
  onSuccess: function() {
    alert("View has been unloaded.");
  },
  onFailure: function() {
    alert("Failed to unload.")
  }
});
{% endhighlight %}

## Example on reusing WebViews via preload.js

A small library called [preload.js](https://github.com/knation/steroids-webview-preload) by Kirk Morales provides an example on effectively reusing preloaded WebViews. The same example as above, using preload.js, works as follows.

{% highlight javascript %}
var webView = new steroids.view.WebView("view.html");
steroids.preload(webView, 'uniqueIdForView', function() {
  steroids.layers.push(webView);
});
{% endhighlight %}

Preload.js adds `steroids.preload` which can be called any amount of times for the same WebView.

Preloaded WebViews are accessed based on their id, which by default is the same as their location, but here we declare it explicitly. This is so that you may have several, separate preloaded WebViews with the same location but different state.

## Caveat: always use the same location string

After the first call to preload, subsequent calls have no effect on the actual location within the WebView. Use the same location string for all WebView objects that are preloaded using a given unique id.

