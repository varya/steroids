---
layout: post
title:  "Tizen Web App preferences in config.tizen.xml"
date:   2013-05-20 13:51:34
categories: tizen
platforms: Tizen
---

###Related Guides
- [Building your app for Tizen][tizen-build-config]

A Steroids app for Tizen is configured via the `www/config.tizen.xml` file. Unlike on iOS and Android, the file is not used to configure Cordova (which is pure JavaScript on Tizen), but rather to set up your Tizen Web App as a whole. `config/application.coffee` is currently not used for Tizen apps. The AppGyver Build Service takes your app, puts your `config.tizen.xml` and app assest in the right place and returns a `.wgt`

You can read more about the [Packaged Web App specification at W3C](http://www.w3.org/TR/widgets/). The Tizen Developer portal has information about [Tizen-specific configuration options](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.appprogramming%2Fhtml%2Fide_sdk_tools%2Fweb_config_ext.htm) configuration .

Let's go through the properties in the default `config.tizen.xml` file:

## General Web App Settings

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" xmlns:tizen="http://tizen.org/ns/widgets"
  id="http://yourdomain/myapp" version="1.0.0" viewmodes="maximized">
  <tizen:application id="com.mydomain.myapp.dev" package="com.mydomain.myapp"
    required_version="2.2"/>
{% endhighlight %}

The `<widget>` tag encloses and defines the whole Tizen Web App. `viewmodes="maximized"` ensures that your app is running in full screen mode without any extra controls, and the `id` attribute is just a unique domain-style string.

The `<tizen:application>` tag's `id` and `package` attributes can be anything, as long as they are unique and contain only alphanumerics and periods.

{% highlight xml %}
<content src="index.html"/>
<icon src="icons/steroids.png"/>
<name>My Steroids App</name>
{% endhighlight %}

These properties determine the initial location of your app (relative to the root of the `www/` folder), the app icon and app display name.

{% highlight xml %}
<feature name="http://tizen.org/feature/screen.size.normal"/>
{% endhighlight %}

The screen size feature is required by Tizen [Application Filtering](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.gettingstarted%2Fhtml%2Ftizen_overview%2Fapplication_filtering.htm) and must be present for the app to show up in Tizen App Stores.

## Privileges and Tizen settings
{% highlight xml %}
<tizen:privilege name="http://tizen.org/privilege/application.launch"/>
<tizen:privilege name="http://tizen.org/privilege/contact.read"/>
<tizen:privilege name="http://tizen.org/privilege/contact.write"/>
<tizen:privilege name="http://tizen.org/privilege/filesystem.read"/>
<tizen:privilege name="http://tizen.org/privilege/filesystem.write"/>
<tizen:privilege name="http://tizen.org/privilege/unlimitedstorage"/>
<tizen:privilege name="http://tizen.org/privilege/setting"/>
{% endhighlight %}

The various `<tizen:privilege>` tags give access to the protected APIs that Cordova requires, plus other Tizen features. See the [API documentation](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.device.apireference%2Ftizen%2Fprivilege.html) for more information.

{% highlight xml %}
<tizen:setting screen-orientation="auto-rotation" context-menu="enable"
  background-support="disable" encryption="disable" install-location="auto"
  hwkey-event="enable"/>
{% endhighlight %}

Read more about the Tizen Settings in the [Tizen Developer Portal](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.appprogramming%2Fhtml%2Fide_sdk_tools%2Fweb_config_ext.htm)

{% highlight xml %}
<tizen:content-security-policy>*</tizen:content-security-policy>
{% endhighlight %}

This overrides the default [Tizen Content Security Policy settings](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.appprogramming%2Fhtml%2Fbasics_tizen_programming%2Fweb_security_privacy.htm), allowing e.g. inline JavaScript execution.

{% highlight xml %}
<tizen:allow-navigation>*</tizen:allow-navigation>
<access origin="*" subdomains="true"></access>
{% endhighlight %}

These tags allow `steroids.layers.push`, `steroids.modal.show`, `steroids.modal.hide` and `steroids.layers.pop` API calls to work with any URL. They are also required by Scanner builds.