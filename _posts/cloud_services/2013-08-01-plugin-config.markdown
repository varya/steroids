---
layout: post
title:  "Custom plugins for your app"
date:   2013-05-22 13:51:34
categories: cloud_services
platforms: Android, iOS
---

### Related Guides
* [Building your app for Android][android-build-config]
* [Building your app for iOS][ios-build-config]
* [Developing custom plugins][developing-custom-plugins]

The AppGyver Build Service, part of [AppGyver Cloud](http://cloud.appgyver.com) allows you to include custom Cordova plugins with your app. To develop locally with the plugins, you need to build (with the Build Service) a custom Scanner app that you download and install onto your device.

First follow the instructions for [building your app on iOS][ios-build-config] or [Android][android-build-config] and set up all the necessary files and settings for your app.

Then, in the Build Service's **Configure iOS/Android Build Settings** page for your app, find the **Plugins** field and include there an array of GitHub repos for the custom plugins you want to use, e.g.

{% highlight json %}
[
  {"source":"https://github.com/AppGyver/emailcomposer-plugin.git"},
  {"source":"https://github.com/AppGyver/steroids-echo-plugin.git"}
]
{% endhighlight %}

**Note:** Steroids currently uses Cordova 2.7.0. This means that Cordova 3.0.0 core plugins are included by default, so you don't need to include e.g. the [Vibration Plugin](https://github.com/apache/cordova-plugin-vibration) to use the Vibration API – in fact, including any of the core plugins will cause your build to fail. The same applies to other plugins installed by default such as the [SQLite Plugin](https://github.com/lite4cordova/Cordova-SQLitePlugin): you can see a list in a new project's `www/config.ios.xml` and `config.android.xml`.

Our Build Service uses the [plugman](https://github.com/apache/cordova-plugman) tool for adding plugins to your custom builds, so your plugin repo must adhere to Cordova's [plugin.xml][plugin-xml-spec] specification, for the platforms you want to target.

**Note that you need to include and load the JavaScript file that loads the plugin (e.g. `EmailComposer.js`) manually in your project – the `<asset>` tag in `plugin.xml` is not supported. The JavaScript file should be available in the `www` folder in the plugin repository.**

Certain plugins require you to pass variables to plugman. You can give these as a property of the individual plugin object:

{% highlight json %}
{
  "source":"https://github.com/my-awesome-organization/my-awesome-plugin.git",
  "variables": {
    "VARIABLE_NAME":"value",
    "SECOND_VAR":"second_value"
  }
}
{% endhighlight %}

There's also a guide available on [developing custom Cordova plugins][developing-custom-plugins].

## Developing locally with custom plugins

The way to use custom plugins in local development is to build a custom Scanner app using the AppGyver Cloud build service. You do need to set up the build config files as indicated in the [Building your app for iOS][ios-build-config]/[Building your app for Android][android-build-config] guides, including the custom plugins you want to use. Then, when you request a Scanner build, you get a Scanner app that includes the custom plugins you need (your actual project files won't be available in the Scanner build - it just functions as a Scanner).

You can then develop locally with the regular Steroids workflow, and you only need to access the build service to build your `.ipa`/`.apk` once you're ready to release your app (or you want to change your plugins).

Please note that you need to manually include your plugin in your Steroids project's `www/config.ios.xml` or `www/config.android.xml` file. This is done by adding the relevant `<plugin>` tag inside the main `<plugins>` tag, e.g.

{% highlight xml %}
<plugins>
  <plugin name="Echo" value="com.appgyver.plugin.Echo" />
</plugins>
{% endhighlight %}

## Known issues

On iOS, our plugins currently require [ARC support](https://developer.apple.com/library/ios/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html), so make sure the code compiles using ARC.

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
[developing-custom-plugins]: /steroids/guides/phonegap_on_steroids/developing-custom-plugins/
[plugin-xml-spec]: http://cordova.apache.org/docs/en/3.0.0/plugin_ref_spec.md.html
