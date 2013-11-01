---
layout: post
title:  "Using custom URL schemes"
date:   2013-10-24 11:31
categories: steroids-js
platforms: iOS, Android
---
### Related guides
* [Building your app for Android][android-build-config]
* [Building your app for iOS][ios-build-config]

Steroids allows you to define custom URL schemes – e.g. `myawesomeapp://` – that let other apps communicate with your apps, e.g. a link in an email can open your app directly and then direct the user to a specific location in your app.

## Usage with Scanner

With AppGyver Scanner, the URL scheme cannot be changed. The scanner is registered with the `steroids-scanner://` URL scheme. To pass data to your app, you can add any string after the URL scheme, including query parameters.

The [`steroids.app.getLaunchURL()`](http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.getLaunchURL.md.html#steroids.app.getLaunchURL) API call is used to retreive the custom URL string used to open the app. For example, if you open the application with `steroids-scanner://login?username=quentin&password=monkey`, `steroids.app.getLaunchURL` returns the whole URL string, URL scheme included. You can then parse it in JavaScript to e.g. get the username and password.

Typically you would want to make the API call inside the Cordova's `resume` event (triggered when the app returns from the background):

{% highlight javascript %}
document.addEventListener("resume", function() {
  alert(steroids.app.getLaunchURL());
});
{% endhighlight %}

It's also a good idea to check in your app initialization code if `steroids.app.getLaunchURL()` returns a nonempty string, for the cases where your app is not running when a link with the custom URL scheme is used.

Note that AppGyver Scanner needs to be running in order to use `steroids-scanner://` URL scheme.  If the application is not running, the scanner screen used to scan QR codes will open with this URL scheme.

Note also that AppGyver Scanner also responds to the `appgyver://` URL scheme, which is used by the Scanner app itself to open specific applications. Opening your Steroids app with the `appgyver://` URL scheme and calling `steroids.app.getLaunchURL` will return `undefined`, so you shouldn't use it in development.

## Creating your own custom URL schemes

You need a custom Ad Hoc or Scanner build to use custom URL schemes. The custom URL schemes are defined in the [Build Service](http://cloud.appgyver.com), in the Build Config section. Enter your URL schemes inside the "Custom Protocols" array, e.g.

{% highlight javascript %}
[
  "myawesomeapp",
  "myawesomeapp-dev"
]
{% endhighlight %}

would register your app for both `myawesomeapp://` and `myawesomeapp-dev://` URL schemes.

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/