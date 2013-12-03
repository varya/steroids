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

You can read more about the [Packaged Web App specification at W3C](http://www.w3.org/TR/widgets/). The Tizen Developer portal has information about [config.xml for Tizen web applications](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.appprogramming%2Fhtml%2Fapp_dev_process%2Fset_widget_web.htm) configuration .

Let's go through the properties in the default `config.tizen.xml` file:

## General Web App Settings

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" xmlns:tizen="http://tizen.org/ns/widgets"
  id="http://yourdomain/myapp" version="1.0.0" viewmodes="maximized">
  <tizen:application id="ChangeThis.MySteroidsApp" package="ChangeThis"
    required_version="2.2"/>
{% endhighlight %}

The `<widget>` tag encloses and defines the whole Tizen Web App. `viewmodes="maximized"` ensures that your app is running in full screen mode without any extra controls, and the `id` attribute is just a unique domain-style string.

The `<tizen:application>` tag's `id` (the application id) and `package` (the package id) identify your app on the Tizen device. The `package` id must match the following criteria:

* Exactly 10 characters long
* Characters may consist of upper and lower case letters and numbers
* Unique in the context of Tizen Application Store

The application `id` begins with your `package` id, followed by a `.` and then a 1-52 character string containing alphanumerics. Remember to change this for a new Steroids project, so you don't get conflicts with existing Steroids projects.

For example: `id="abcDE12345.MySteroidsApp" package="abcDE12345"`

{% highlight xml %}
<content src="index.html"/>
<icon src="icons/steroids.png"/>
<name>My Steroids App</name>
{% endhighlight %}

These properties determine the initial location of your app (relative to the root of the `www/` folder), the app icon and app display name.

{% highlight xml %}
<feature name="http://tizen.org/feature/screen.size.normal.480.800"/>
{% endhighlight %}

The screen size feature is required by Tizen [Application Filtering](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.gettingstarted%2Fhtml%2Ftizen_overview%2Fapplication_filtering.htm) and must be present for the app to show up in Tizen App Stores.

## Privileges and Tizen settings
{% highlight xml %}
<tizen:privilege name="http://tizen.org/privilege/application.launch"/>
<tizen:privilege name="http://tizen.org/privilege/contact.read"/>
<tizen:privilege name="http://tizen.org/privilege/contact.write"/>
<tizen:privilege name="http://tizen.org/privilege/filesystem.read"/>
<tizen:privilege name="http://tizen.org/privilege/filesystem.write"/>
{% endhighlight %}

The various `<tizen:privilege>` tags give access to the protected APIs that Cordova requires, plus other Tizen features. See the [API documentation](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.device.apireference%2Ftizen%2Fprivilege.html) for more information.

{% highlight xml %}
<tizen:setting screen-orientation="auto-rotation" context-menu="enable"
  background-support="disable" encryption="disable" install-location="auto"
  hwkey-event="enable"/>
{% endhighlight %}

Read more about the Tizen Settings in the [Tizen Developer Portal](https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.web.appprogramming%2Fhtml%2Fapp_dev_process%2Fediting_tizen.htm)

{% highlight xml %}
<tizen:allow-navigation>*</tizen:allow-navigation>
<access origin="*" subdomains="true"></access>
{% endhighlight %}

These tags allow `steroids.layers.push`, `steroids.modal.show`, `steroids.modal.hide` and `steroids.layers.pop` API calls to work with any URL. They are also required by Scanner builds.

[tizen-build-config]: /steroids/guides/cloud_services/tizen-build-config/
