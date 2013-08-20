---
layout: post
title:  "Configuring custom plugins for your app"
date:   2013-05-21 13:51:34
categories: cloud_services
platforms: Android, iOS
---

### Related Guides
* [Building your app for Android][android-build-config]
* [Building your app for iOS][ios-build-config]

The AppGyver Build Service allows you to define custom Cordova plugins for your app.

First follow the instructions for building your app on iOS or Android (linked in the Related Guides section above). Then, in the plugins field, include an array of GitHub repos for the custom plugins you want to use, e.g.

{% highlight json %}
[
  {"source":"https://github.com/apache/cordova-plugin-geolocation.git"},
  {"source":"https://github.com/apache/cordova-plugin-vibration.git"},
  {"source":"https://github.com/phoenix-foundation/steroids-plugin-awesome.git"}
]
{% endhighlight %}

The repo must have a adhere to Cordova's [plugin.xml][plugin-xml-spec] specification for the platforms you want to target.

## Known issue

Currently, there's a known issue with private GitHub repos accessed with a Basic Auth token, e.g. `https://richard.anderson:myawesometoken@github.com/phoneix-foundation/steroids-plugin-awesome.git`. If you need to use a private repo for your plugin, please contact us at [support@appgyver.com](mailto:support@appgyver.com).

## config.xml

If you are building a custom Scanner app for your project, note that you need to manually include your plugin in your Steroids project's `www/config.ios.xml` or `www/config.android.xml` file. This is done by adding the relevant `<plugin>` tag inside the main `<plugins>` tag, e.g.

{% highlight xml %}
<plugins>
  <plugin name="AwesomePlugin" value="org.phoneixfoundation.plugins.AwesomePlugin" />
</plugins>
{% endhighlight %}

Currently, you need to also include the relevant `.js` and other asset files for the plugin manually in your project – the `<asset>` tag in `plugin.xml` is not supported.

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[plugin-xml-spec]: http://cordova.apache.org/docs/en/3.0.0/plugin_ref_spec.md.html
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
