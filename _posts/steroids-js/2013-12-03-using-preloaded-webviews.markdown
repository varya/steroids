---
layout: post
title:  "Using preloaded WebViews"
date:   2013-10-24 11:31
categories: steroids-js
platforms: iOS, Android
---
Initializing and loading the contents of a new WebView takes a bit of time. In case you know that you are going to be needing a specific WebView later, you can preload it to improve user experience.

## Preloading a WebView

The basic use of `preload()` is rather straightforward. The following code will perform a preload and push a view onto the layer stack once preloading has successfully started, e.g. the preloaded WebView exists in the native side memory:

{% highlight javascript %}
var webView = new steroids.views.WebView("settings.html");
webView.preload({}, {
  onSuccess: function() {
    steroids.layers.push(webView);
  }
});
{% endhighlight %}

The `preload()` function's success callback is fired when the new WebView has been initialized and its target HTML document starts loading. Note that the success callback doesn't ensure anything about the state of the target HTML document – if you need to know when the HTML document is actually fully loaded into the memory, using `window.postMessage` to broadcast a "This WebView is now ready" message is a good way to do it.

The WebView completes loading in the background and remains active (executing JavaScript, loading content and so forth) – the state doesn't change when it is pushed into the layer stack with `steroids.layers.push(webView)`.

Popping a preloaded WebView object doesn't remove it from memory, so if you push the same WebView object back into the layer stack, it will have continued to run outside the layer stack.

A non-preloaded WebView waits for the `DOMContentLoaded` event before it can be pushed into the layer stack, whereas a preloaded view can be pushed instantly. Using preloaded views gives your app a very snappy and native-like feeling.

##Accessing same preloaded WebView from different locations

The confusion begins when you try access the same preloaded WebView – say, `settings.html` – from multiple places in your app. You cannot simply execute the code above in each WebView in your app, as the `webView.preload()` API call will fail after the first time. This happens because the native side identifies preloaded WebViews by **unique IDs**, and only one WebView with a given ID can exist on the native side. So, how does a WebView get an ID?

###Way one: successful webViewObject.preload() call.

A simple `webViewObject = new steroids.views.WebView("settings.html")` creates a WebView object that has no `id` parameter set:

{% highlight javascript %}
webViewObject: {
	location: "settings.html",
	id: null
}
{% endhighlight %}

But a preloaded WebView has to have an `id`, so when you call `webViewObject.preload()` without any parameters, the `id` is set to the value of `webViewObject.location`:

{% highlight javascript %}
webViewObject: {
	location: "settings.html",
	id: "settings.html"
}
{% endhighlight %}

However, note that the `id` parameter is set only after the `webViewObject.preload()` call is successful on the native side. After a successful call, the native side preloaded WebView also has the ID `"settings.html"`.

###Way two: set as a parameter to the preload API call

If you call `webViewObject.preload({id: "myAwesomeId"})`, the `id` field gets set (again, only after the `preload` call returns from the native side successfully):

{% highlight javascript %}
webViewObject: {
	location: "settings.html",
	id: "myAwesomeId"
}
{% endhighlight %}

The native side preloaded WebView now has ID `"myAwesomeId"`.

###Way three: set in the WebView constructor

You can also set the `id` in the constructor; e.g. <br>`webViewObject = new steroids.views.WebView({location: "settings.html", id: "myAwesomeId"})`:

{% highlight javascript %}
webViewObject: {
	location: "settings.html",
	id: "myAwesomeId"
}
{% endhighlight %}

Note that here, the `id` is set without having to call `webViewObject.preload()`. This also means that there might not be a preloaded WebView with a matching ID in the native side memory.

You can see how setting the `id` property and communicating with the native side works in the [Steroids.js source](https://github.com/AppGyver/steroids-js/blob/master/src/models/views/WebView.coffee).

## WebView ID check happens during steroids.layers.push

When you call `steroids.layers.push(webViewObject)`, the native side checks for the existence of an `id` property in the WebView object. If there's one, it then checks if a preloaded WebView with a matching ID is found. If the native side finds a preloaded layer with the given ID, it'll push that to the layer stack (at this point, the `location` property of the WebView object doesn't matter anymore, since the preloaded view already has its `window.location` set).

If the `id` property doesn't match any preloaded WebViews or it's missing completely, a completely new WebView will be pushed to the layer stack, with the `location` property determining which HTML document is loaded.

Now, it's important to understand that WebViews in the native side memory and the JavaScript objects in each WebView are not synced in any way - the checks only happen during API calls such as `webViewObject.preload()` or `steroids.layers.push(webViewObject)`.

##How to use this in practice?

Basically, you want to only call `webViewObject.preload()` once per each view you want to preload, and then ensure that whenever you call `steroids.layers.push(webViewObject)`, the `webViewObject.id` property matches the desired preloaded WebView's ID.

You can achieve this by ensuring that during your app initialization, a single view (e.g. the initial `index.html`) calls `preload()` for each view you want to preload:

{% highlight javascript %}
var settingsView = new steroids.views.WebView({location: "settings.html", 
  id: "settingsView");
var aboutView = new steroids.views.WebView({location: "about.html", 
  id: "aboutView");

settingsView.preload();
aboutView.preload();
{% endhighlight %}

Then, in every other view that might push preloaded views to the layer stack, you set the `id` property in the WebView constructor – you never have to call `preload()`:

{% highlight javascript %}
var settingsView = new steroids.views.WebView({location: "settings.html", 
  id: "settingsView");
var aboutView = new steroids.views.WebView({location: "about.html", id: 
  "aboutView");

steroids.layers.push(settingsView); //pushes the preloaded WebView
{% endhighlight %}

Now, whenever you do `steroids.layers.push(settingsView)`, the preloaded settings view is used. Note that if the preloaded WebView already exists in the layer stack, it cannot be pushed again before it is first popped.

## IDs for initial WebViews

The native preload ID of the initial view is set to match the value of `steroids.config.location` in `config/application.coffee`. If using the tab bar, the native preload ID of each view matches the `location` property of the tab object.

## Unloading a preloaded WebView

A preloaded webview can be unloaded. Contrary to `steroids.layers.pop()`, unloading a WebView removes it from memory. The use of `unload()` is pretty simple:

{% highlight javascript %}
var webView = new steroids.views.WebView("view.html");
webView.unload({}, {
  onSuccess: function() {
    alert("View has been unloaded.");
  },
  onFailure: function() {
    alert("Failed to unload.")
  }
});
{% endhighlight %}


