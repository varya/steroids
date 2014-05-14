---
layout: post
title:  "Accessing preloaded WebViews"
date:   2014-05-14 11:31
categories: steroids-js
platforms: iOS, Android
---

Usually when you have preloaded a WebView, you will want to access it several times, possibly from different places. Esentially this is possible via the `id` property of your WebView. See [Preloading a WebView with an id](/steroids/guides/steroids-js/preloading-webview-with-id/) for info on preloading WebViews with ids.

## WebView ID check happens during steroids.layers.push

When you call `steroids.layers.push(webViewObject)`, the native side checks for the existence of an `id` property in the WebView object. If there's one, it then checks if a preloaded WebView with a matching ID is found. If the native side finds a preloaded layer with the given ID, it'll push that to the layer stack. If the `id` property doesn't match the ID of any preloaded WebViews, the `steroids.layers.push` call will initiate a load function for the WebView.

It's important to understand that WebViews in the native side memory and the JavaScript objects in each WebView are not synced in any way - the checks only happen during API calls such as `webViewObject.preload()` or `steroids.layers.push(webViewObject)`.

##How to use this in practice?

Assuming you have properly preloaded the WebViews, accessing them is very simple. Any time that you might push preloaded views to the layer stack, you set the `id` property in the WebView constructor so that it matches the id of a previously preloaded WebView and just push it into view – you never have to call `preload()`:

```javascript
var settingsView = new steroids.views.WebView({
  location: "settings.html", 
  id: "settingsView"
});

var aboutView = new steroids.views.WebView({
  location: "about.html", 
  id: "aboutView"
});

steroids.layers.push(settingsView); //pushes the preloaded WebView
```

Now, whenever you do `steroids.layers.push(settingsView)`, the preloaded settings view is used (given that it is preloaded). Note that if the preloaded WebView already exists in the layer stack, it cannot be pushed again before it is first popped.

## Android known issue

On Android, you can only push preloaded WebViews from the same WebView where you preloaded them. Otherwise, it'll simply push a brand new WebView, ignoring the preloaded one. This causes the `loading.png` image to show.

One workaround is to preload all webviews from a preloaded `background.html` WebView, which is never pushed to the navigation stack, and then push all layers from there too. You can then use `window.postMessage` from other WebViews to message `background.html` every time you want to push a preloaded WebView.

## Preload at app start

Usually you will want to preload some WebViews at app start. This can be achieved in a few different ways. [Preload at app start](/steroids/guides/steroids-js/preload-at-app-start/) details the necessary steps.









