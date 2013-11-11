---
layout: post
title:  "Migrating to Cordova 3.1.0"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS, Android
---

Migration to Cordova 3.1.0 will bring about some changes. First, all the plugins are now configured only via Build Service. Please note that the Cordova core features are now considered as plugins as well. However, they all are included by default in Scanner, so you just need to choose, which ones you want in your project via Build Service. In addition to the COrdova core features the following plugins are included by default in Scanner:
* [BarcodeScanner](https://github.com/wildabeast/BarcodeScanner)
* [SQLite](link-to-repo)
* [Google Analytics](link-to-repo)


Second, the `config.ios.xml´ and `config.android.xml` have been changed. To make the necesssary changes to your existing projects, we recommend that you copy the new versions from a fresh Steroids project.


## Automatic plugin JavaScript inclusion

With Cordova 3.1.0, you no longer need to manually download and include any plugin JavaScript files for your project. There are two ways, plugman and Cordova, to automatically include JavaScript files for plugins. You need to check the `plugin.xml` file for each plugin you install to see which method they use:

* The `<asset>` element just includes the plugin's JavaScript file in your app. The file won't show up in the project structure, but will be available on the device. You need to manually include a `<script>` tag in your HTML to load the JavaScript file.
* The `<js-module>` element both includes the plugin's JavaScript file and also injects the relevant `<script>` tag into the DOM of all WebViews.

Thus, if your plugins use the `<asset>` element, you need to remove any plugin-specific JavaScript files from your project, and ensure that all the `<script>` tags load the files from the correct path.

If your plugins use the `<js-module>` element, then you need to both remove any plugin-specific JavaScript files as well as any `<script>` tags, bacause everything is done automatically.

A properly-coded Cordova plugin should not execute any code on load, but wait for an `init()` call or similar, so there's no harm in having the `<script>` tag injected to each view.

