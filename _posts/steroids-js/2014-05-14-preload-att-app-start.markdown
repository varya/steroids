---
layout: post
title:  "Preload at app start"
date:   2014-05-14 11:31
categories: steroids-js
platforms: iOS, Android
---

Often you will have a set of WebViews that need to be loaded at app start, such as drawers or your app's main WebViews.

## IDs for initial WebViews

The native preload ID of the initial view is set to match the value of `steroids.config.location` in `config/application.coffee`. If using the tab bar, the native preload ID of each view matches the `location` property of the tab object.

## Manual preload at app start

Calling `preload()` for the same WebView more than once will result in the `preload()` function to fail. Basically, for an often used view you want to only call `webViewObject.preload()` once, and then ensure that whenever you call `steroids.layers.push(webViewObject)`, the `webViewObject.id` property matches the desired preloaded WebView's ID.

You can achieve this by ensuring that during your app initialization, a single view (e.g. the initial `index.html`) calls `preload()` for each view you want to preload:

```javascript
var settingsView = new steroids.views.WebView({
  location: "settings.html", 
  id: "settingsView"
});

var aboutView = new steroids.views.WebView({
  location: "about.html", 
  id: "aboutView"
});

settingsView.preload();
aboutView.preload();
```

Now, you can access the preloaded WebViews anywhere by utilizing their `id` property.

## Android known issue

On Android, you can only push preloaded WebViews from the same WebView where you preloaded them. Otherwise, it'll simply push a brand new WebView, ignoring the preloaded one. This causes the `loading.png` image to show.

One workaround is to preload all webviews from a preloaded `background.html` WebView, which is never pushed to the navigation stack, and then push all layers from there too. You can then use `window.postMessage` from other WebViews to message `background.html` every time you want to push a preloaded WebView.

## steroids.config.preloads (iOS-only)

Automatically preloading WebViews for non-tab locations can be achieved with the `steroids.config.preloads` array in `config/application.coffee`. The preloads array consists of objects that define the `location` and `id` of a WebView to be preloaded. It is important to add the `http://localhost/` prefix to the `location` property, so the files are served via localhost.

```javascript
steroids.config.preloads = [
  {
    id: "carsShow"
    location: "http://localhost/views/cars/show.html"
  }
  {
    id: "carsEdit"
    location: "http://localhost/views/cars/edit.html"
  }
]
```

The views listed will be preloaded before the app starts and are immediately accessible via their ids, such as:

```javascript
var carsView = new steroids.views.WebView({id: "carsShow"})
steroids.layers.push(carsView)
```








