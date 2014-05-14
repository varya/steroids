---
layout: post
title:  "Preloading a WebView with an id"
date:   2014-05-14 11:31
categories: steroids-js
platforms: iOS, Android
---

Usually when you preload a WebView, you don't want to immediately push it into view. In order to access it later, you will need to have access to it's id, which can be set in one of three ways.

###Way one: successful webViewObject.preload() call.

A simple `webViewObject = new steroids.views.WebView("settings.html")` creates a WebView object that has no `id` parameter set:

```javascript
webViewObject: {
	location: "settings.html",
	id: null
}
```

But a preloaded WebView has to have an `id`, so when you call `webViewObject.preload()` without any parameters, the `id` is set to the value of `webViewObject.location`:

```javascript
webViewObject: {
	location: "settings.html",
	id: "settings.html"
}
```

However, note that the `id` parameter is set only after the `webViewObject.preload()` call is successful on the native side. After a successful call, the native side preloaded WebView also has the ID `"settings.html"`.

###Way two: set as a parameter to the preload API call

If you call `webViewObject.preload({id: "myAwesomeId"})`, the `id` field gets set (again, only after the `preload` call returns from the native side successfully):

```javascript
webViewObject: {
	location: "settings.html",
	id: "myAwesomeId"
}
```

The native side preloaded WebView now has ID `"myAwesomeId"`.

###Way three: set in the WebView constructor

You can also set the `id` in the constructor; e.g.

```javascript
webViewObject = new steroids.views.WebView({location: "settings.html", id: "myAwesomeId"})
```

That will result in:

```javascript
webViewObject: {
	location: "settings.html",
	id: "myAwesomeId"
}
```

Note that here, the `id` is set without having to call `webViewObject.preload()`. This also means that there might not be a preloaded WebView with a matching ID in the native side memory.

You can see how setting the `id` property and communicating with the native side works in the [Steroids.js source](https://github.com/AppGyver/steroids-js/blob/master/src/models/views/WebView.coffee).

See [Accessing preloaded WebViews](/steroids/guides/steroids-js/access-preloaded-webviews/) for a guide on accessing your WebViews after you have preloaded them.