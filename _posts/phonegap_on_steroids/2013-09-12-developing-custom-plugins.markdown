---
layout: post
title:  "Developing custom Cordova plugins"
date:   2013-09-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS, Android
---

## Related Guides
* [Configuring custom plugins for your app][custom-plugin-config]

*NB: The content below is from the official [Cordova plugin development guide][cordova-plugin-guide], with a few Steroids-specific modifications and clarifications.*

A Cordova plugin bridges a bit of functionality between the WebView powering a Cordova application and the native platform the Cordova application is running on. Plugins are composed of a single JavaScript interface used across all platforms, and native implementations following platform-specific Plugin interfaces that the JavaScript calls into. All of the core Cordova APIs are implemented using this architecture (Steroids.js APIs use a different native bridge, but the concept is the same).

This guide goes throug the process of writing a simple Echo Plugin that passes a string from JavaScript and sends it into the native environment for the supported platforms. The native code then returns the same string back to the callbacks inside the plugin's JavaScript.

##JavaScript

The entry point for any plugin is the front-facing JavaScript interface.

You can structure your plugin's JavaScript however you like. The one thing you must use to communicate between the Cordova JavaScript and native environments is the `cordova.exec` function. Here is an example:

{% highlight javascript %}
cordova.exec(function(successParam) {}, function(errorParam) {}, "service",
  "action", ["firstArgument", "secondArgument", 41,
  false]);
{% endhighlight %}

The parameters are detailed below:

* `function(successParam) {}`: Success function callback. Assuming your exec call completes successfully, this function is invoked (optionally with any parameters you pass back to it from the native side).
* `function(errorParam) {}`: Error function callback. If the operation does not complete successfully, this function is invoked (optionally with any error parameters passed back to it from the native side).
* `"service"`: The service name to call into on the native side. This is mapped to a native class, about which more information is available in the platform-specific guides linked below.
* `"action"`: The action name to call into. This is picked up by the native class receiving the `exec` call, and, depending on the platform, essentially maps to a class's method. The native guides linked below provide more details.
* `[/* arguments */]`: An array of arguments to pass into the native environment.

### Echo Plugin JavaScript Example

{% highlight javascript %}
window.echo = function(str, callback) {
    cordova.exec(callback, function(err) {
        callback('Nothing to echo.');
    }, "Echo", "echo", [str]);
};
{% endhighlight %}

Let's dive into this. The plugin attaches itself to the `window` object, specifically to the `echo` function. Plugin users would then use it as follows:

{% highlight javascript %}
window.echo("echome", function(echoValue) {
    alert(echoValue == "echome"); // should alert true
});
{% endhighlight %}

First, let's take a look at the last three arguments to the `exec` function. We will be calling the `Echo` "service", requesting the `echo` "action", and passing an array of arguments containing the echo string, which is the first parameter into the `window.echo` function.

The success callback passed into `exec` is simply a reference to the callback function that `window.echo` takes. We do a bit more for the error callback: if the native side fires off the error callback, we simply invoke the success callback and pass into it a default error message string.

### Plugin Specification

Cordova has a plugin specification available to enable automated installation of plugins for Android and iOS platforms by using [plugman][plugman]. The Steroids Build Service uses plugman internally, so you need to structure your plugin in a particular way and add a `plugin.xml` manifest file. You also need to host your plugin in a git repo, so that the Build Service can fetch the plugin – we recommend [GitHub][github].

*Note that Steroids currently requires you to include the JavaScript file for your plugin manually in your project; the `<asset>` tag is not supported.*

* [Plugin Specification at (cordova.apache.org)][cordova-plugin-spec]

##Native Code

Once you define JavaScript for your plugin, you need to complement it with at a native implementation for at least one platform. Detailed instructions for each platform are linked below. These guides continue to build on the simple Echo Plugin example discussed above.

 * [Android Plugins (at cordova.apache.org)][cordova-android-plugin]
 * [iOS Plugins (at cordova.apache.org)][cordova-ios-plugin]

##Example plugin on GitHub

You can find an example of a properly set up Echo plugin repository on [GitHub][steroids-echo-plugin].

##Kitchensink example

You can see an example of the Echo plugin in action in the [Steroids Kitchensink][steroids-kitchensink] project. Note that you need to build a [custom Scanner app][custom-plugin-config] with the plugin included for the example to work (you can use the above [GitHub repo][steroids-echo-plugin] as the source).

[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[steroids-kitchensink]: https://github.com/AppGyver/kitchensink
[steroids-echo-plugin]: https://github.com/AppGyver/steroids-echo-plugin/
[github]: https://github.com
[plugman]: https://github.com/apache/cordova-plugman
[cordova-plugin-spec]: http://cordova.apache.org/docs/en/3.0.0/plugin_ref_spec.md.html#Plugin%20Specification
[cordova-android-plugin]: http://cordova.apache.org/docs/en/3.0.0/guide_platforms_android_plugin.md.html#Android%20Plugins
[cordova-ios-plugin]: http://cordova.apache.org/docs/en/3.0.0/guide_platforms_ios_plugin.md.html#iOS%20Plugins
[cordova-plugin-guide]: http://cordova.apache.org/docs/en/3.0.0/guide_hybrid_plugins_index.md.html#Plugin%20Development%20Guide