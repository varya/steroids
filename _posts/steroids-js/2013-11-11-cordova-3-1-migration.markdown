---
layout: post
title:  "Migrating to Cordova 3.1"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS, Android
staging: true
---

Updating all Steroids components (Scanner, Steroids.js, Steroids CLI) to support Cordova 3.1 has brought about some breaking changes that need to be taken into account in your project.

## cordova.js must be loaded from localhost root

Make sure that `cordova.js` is loaded from localhost root, and not a subfolder (previous templates loaded it from `http://localhost/appgyver/cordova.js`):

{% highlight html %}
<script scr="http://localhost/cordova.js"></script>
{% endhighlight %}

This also applies if you're not using the `http://localhost/` prefix:

{% highlight html %}
<script scr="/cordova.js"></script>
{% endhighlight %}

## config.xml changes

The `config.ios.xml` and `config.android.xml` files have changed to conform more srtictly to the [W3C Packaged Web Apps specification](http://www.w3.org/TR/widgets/) – the easiest way to see the changes is to create a new Steroids project with the latest Steroids CLI version. You can also take a look at the updated [iOS config.xml][ios-config-xml] and [Android config.xml][android-config-xml] guides.

### Plugins are configured via Build Service only

All plugins are now configured solely via the Build Service. This means that they aren't defined anymore in the local `config.ios.xml` and `config.android.xml` files. Any existing `<plugin>` elements should be removed from your config files. This applies to Cordova core features also.

### Default plugins included in the AppGyver Scanner
By default, the AppGyver Scanner app includes all Cordova core plugins, as well as the following third-party plugins:

* [Barcode Scanner](https://github.com/AppGyver/BarcodeScanner.git)
* [SQLite](https://github.com/lite4cordova/Cordova-SQLitePlugin.git)
* [Google Analytics](https://github.com/AppGyver/GAPlugin.git)

To change which plugins are included in your app, you need to build a custom build of your app – see the build guide for [iOS][ios-build-config] and for [Android][android-build-config]

## Automatic plugin JavaScript inclusion

With Cordova 3.1.0, you no longer need to manually download and include any plugin JavaScript files for your project. There are two ways, plugman and Cordova, to automatically include JavaScript files for plugins. You need to check the `plugin.xml` file for each plugin you install to see which method they use:

* The `<asset>` element just includes the plugin's JavaScript file in your app. The file won't show up in the project structure, but will be available on the device. You need to manually include a `<script>` tag in your HTML to load the JavaScript file.
* The `<js-module>` element both includes the plugin's JavaScript file and also injects the relevant `<script>` tag into the DOM of all WebViews.

**If your plugins use the `<asset>` element**, you need to remove any plugin-specific JavaScript files from your project, and ensure that all the `<script>` tags load the files from the correct path.

**If your plugins use the `<js-module>` element,** you need to both remove any plugin-specific JavaScript files as well as any `<script>` tags, bacause everything is done automatically.

A properly-coded Cordova plugin should not execute any code on load, but wait for an `init()` call or similar, so there's no harm in having the `<script>` tag injected to each view.

## Viewport meta tag known issue (iPhone-only)

When using the `EnableViewportScale` iOS `config.xml` preference, there's a [known Cordova issue](https://issues.apache.org/jira/browse/CB-4323) that affects the `<meta name="viewport">` tag (on iPhone only).

What happens is that the `width=device-width` and `height=device-height` attributes do not set the viewport dimensions correctly. A solution is to remove them, and use the various `scale` attributes instead:

{% highlight html %}
<meta name="viewport" content="user-scalable=no, initial-scale=1,
maximum-scale=1, minimum-scale=1, target-densitydpi=device-dpi" />
{% endhighlight %}

[ios-config-xml]: /steroids/guides/project_configuration/config-xml-android/
[android-config-xml]: /steroids/guides/project_configuration/config-xml-ios/
[ios-build-config]: /steroids/guides/cloud_services/ios_build_config
[android-build-config]: /steroids/guides/cloud_services/android_build_config