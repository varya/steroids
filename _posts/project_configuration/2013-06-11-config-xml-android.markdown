---
layout: post
title:  "Android Cordova preferences in config.android.xml"
date:   2013-05-20 13:51:34
categories: project_configuration
platforms: Android
---

###Related Guides
* [Cordova preferences in config.xml (iOS)][config-xml-ios-guide]

Like Cordova, Steroids uses a `config.xml` file to set universal preferences for WebViews in your app, manage which Cordova plugins are loaded and set whitelisted domains for your app. The structure of `config.xml` is based on the [W3C Packaged Web Apps (Widgets)][widgets] specification, although only a limited set of the available elements are used.

The Android-specific `config.xml` is located at `www/config.android.xml`.

##Configuring preferences

Currently, Steroids doesn't support the preference elements of Cordova's `config.xml` on Android. For more information on the preferences, see the relevant [Cordova documentation][cordova-android-config-xml].

##Configuring plugins

By removing `<plugin>` elements from the `config.xml` file, you can disable parts of Cordova. Note that you normally shouldn't need to disable individual plugins even for production apps – there's no real memory impact if the plugins aren't invoked via JavaScript.

For more information on the API calls associated with each core plugin, see the [Steroids API docs][steroids-api].

Unlike Cordova, Steroids doesn't support `<feature>` elements in place of `<plugin>` elements.

##Domain whitelisting
The `<access>` element manages whitelisted domains for your app. For most cases, you are safe to allow all domains:

{% highlight html %}
<access origin="*" />
{% endhighlight %}

For more granular control, see the [Cordova Docs][cordova-domain-whitelisting] on the subjcet.

##App start location
The `<content>` tag is not used in Steroids to set the initial location of your app. Instead, the `steroids.config.location` property in `config/application.coffee` is used.

[widgets]: http://www.w3.org/TR/widgets/
[cordova-domain-whitelisting]: http://cordova.apache.org/docs/en/2.7.0/guide_whitelist_index.md.html#Domain%20Whitelist%20Guide
[steroids-api]: http://docs.appgyver.com
[config-xml-ios-guide]: /steroids/guides/project_configuration/config-xml-ios/
[cordova-android-config-xml]: http://cordova.apache.org/docs/en/2.7.0/guide_project-settings_android_index.md.html#Project%20Settings%20for%20Android