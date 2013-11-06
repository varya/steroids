---
layout: post
title:  "Sharing data between multiple WebViews"
date:   2013-10-24 11:31
categories: steroids-js
platforms: iOS, Android
---

The Steroids Multi-Page App architecture differs from Single-Page App architecture in several ways, and sharing data between various parts of your application is one part that requires different techniques. The most important thing to understand is that each `steroids.views.WebView` object you have in your layer stack (or [preloaded to memory](/steroids/guides/steroids-js/sharing-data-between-webviews/)) is a separate "browser instance", with its own DOM and JavaScript runtime.

This means that you cannot create "global" JavaScript variables, that [singletons](http://en.wikipedia.org/wiki/Singleton_pattern) such as AngularJS [services](http://docs.angularjs.org/guide/dev_guide.services.creating_services) are not unique (since the code is loaded multiple times, once per WebView, and AngularJS maintains the service singleton separately for each `ng-app` instance), and so on.

However, Steroids has implemented certain HTML5 standards and other functionalities that overcome these limitations and let you do everything a Single-Page App could do.

## window.postMessage

Steroids implements the [`window.postMessage` API](https://developer.mozilla.org/en-US/docs/Web/API/Window.postMessage) to enable communication between different WebViews. The basic usage is simple: a WebView calls the `window.postMessage()` function with a certain message. The message event is broadcasted to all other WebViews, who can receive it by listening to the `window` `message` event.

As an example, we have the following code in `index.html`

{% highlight javascript %}
function broadcastMessage(msg) {

  message = {
    recipient: "showView",
    message: "Hi Show view!"
  }

  window.postMessage(message);

}
{% endhighlight %}

And then in `show.html`, which is running in a separate WebView:

{% highlight javascript %}
function messageReceived(event) {

  // check that the message is intended for us
  if (event.data.recipient == "showView") {
    alert(event.data.message)
  }
}

window.addEventListener("message", messageReceived);

{% endhighlight %}

The Steroids usage of `postMessage` is a bit simplified: we do not use the `event.origin` and `event.source` attributes of the received event, nor do we give a `targetOrigin` for the `window.postMessage` API call. Since a Steroids app is is "walled-off" from the general Internet inside the app package, all `postMessage` calls are automatically posted to every WebView in memory. It is then up to the sender and receiver to ensure that messages are handled by the correct WebViews.

`window.postMessage` is tremendously useful and even necessary for many functionalities of your Multi-Page App – learn to use it well. Implementing a small publisher/subscriber library for your app is a good idea to ensure that `postMessage`s flow smoothly.

See `$ steroids generate example drawer` for an example of using `window.postMessage` with the native Drawer.

## window.localStorage

[`window.localStorage`](http://diveintohtml5.info/storage.html) is shared between all WebViews in your app. Thus, an item saved with `localStorage.setItem()` in one WebView (e.g. `index.html`) can be retreived from another WebView (e.g. `show.html`) with `localStorage.getItem()`.

**Hint:** to save objects to `localStorage`, you can use `JSON.stringify(object)` to convert your object to a String, and then `JSON.parse(object_as_string)` to convert it back to an object.

An important difference to browser apps is that the user won't have access to developer tools for your WebViews. Thus, they cannot manipulate `localStorage` directly – everything you save there remains, even over app updates (of course, cleaning the app cache will empty `localStorage` also).

## Other databases

You can also use a more robust database for sharing data between your WebViews. An example is the PhoneGap SQLite plugin, which is bundled with the AppGyver Scanner. See the <br>`$ steroids generate ng-sql-scaffold banana` generator and the [Using a local prepopulated SQLite database guide](/steroids/guides/phonegap_on_steroids/prepopulated-sqlite/) for more information.

Note that using a database can be pretty heavy-duty – `window.localStorage` is often enough for simple app settings, session tokens etc.

## Using a preloaded background HTML document

As an extension to the other techniques above, you can preload a special `backgroundServices.html` (it can be any name) document to serve as an always-there "master document", that will e.g. house the singletons you have in your app. In the initial view of your app, you can run:

{% highlight javascript %}
var backgroundView = new steroids.views.WebView("backgroundServices.html")

backgroundView.preload();
{% endhighlight %}

Using an AngularJS service as an example, you would have a separate `BackgroundServiceApp` `ng-app` that loads your background service(s). Then, you use `postMessage` to interact with the services. By making the AngularJS service singleton the final target of all `postMessage` events, AngularJS should take care of any possible race conditions automatically. Note that you will never need to display the background WebView to the user – just use it to handle your app's global states from a single place.
