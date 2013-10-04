---
layout: post
title:  "Using Cordova CLI with your Steroids project"
date:   2013-10-04 13:51:34
categories: steroids_npm
platforms: Android, iOS
---

Starting with version 2.7.26 of Steroids npm, new Steroids projects include `.cordova` and `platforms` folders. This enables you to use the [Cordova CLI](https://github.com/apache/cordova-cli) in your Steroids project folder to create, build and run native Xcode/Eclipse Cordova projects that use your `www` folder for the HTML5 content.

**The support is currently limited** – you cannot run your Steroids app properly via Xcode or Eclipse, since Steroids.js features are not available in the vanilla Cordova runtime, the `www` folder is copied over instead of `dist` and so on. The main use case currently is to facilitate [custom plugin development][developing-custom-plugins] – you don't have to create a whole separate Cordova project. We will be improving the integration as we go along.

## Using Cordova CLI

More detailed insturctions and troubleshooting advice are available in the [Cordova CLI readme](https://github.com/apache/cordova-cli/blob/master/README.md), but you can install Cordova CLI easily via npm:

{% highlight bash %}
$ npm install cordova -g
{% endhighlight %}

Then, simply go to your Steroids project folder (make sure it's one you've created with Steroids npm v2.7.26 or newer) add your platform (requires Xcode and Eclipse to be set up properly – see the [Cordova CLI readme](https://github.com/apache/cordova-cli/blob/master/README.md) for troubleshooting):

{% highlight bash %}
$ cordova platform add ios
$ cordova platform add android
{% endhighlight %}

Your `platforms/ios` and `platforms/android` folders will now have an Xcode/Eclipse project with your `www` folder copied over.

By default, Cordova shows the `www/index.html` file. You can change this at `platforms/ios/HelloCordova/config.xml` and `platforms/android/res/xml/config.xml` – since they are not directly compatible, it's a good idea to create something like `www/cordova.html` for plugin development.

Cordova doesn't support localhost, so you need to change your `<script>` tags so that they load `cordova.js` directly from the `www` root (Cordova CLI takes care of creating the correct platform-specific `cordova.js`):

{% highlight html %}
<script src="cordova.js"></script>
{% endhighlight %}

After this, you can open and compile your projects via Xcode or Eclipse and use the `$ cordova prepare` command to copy your `www` folder to the correct location in the native projects. You can also use Cordova's built-in simulators/emulators:

{% highlight bash %}
$ cordova build ios
$ cordova run ios
{% endhighlight %}
