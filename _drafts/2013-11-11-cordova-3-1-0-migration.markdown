---
layout: post
title:  "Migrating to Cordova 3.1.0"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS, Android
---

- migration to Cordova 3.1.0 brings some changes
- plugins are now configured via build service only
- cordova core features are now plugins also
  - all are included by default in Scanner
  - choose which ones you want in your project via Build Service
- ADD List of plugins included by default and their github repos
- config.ios.xml and config.android.xml have been changed: instruct users to copy new versions over from a fresh Steroids CLI project


## Automatic plugin JavaScript inclusion

With Cordova 3.1.0, you no longer need to manually download and include any plugin JavaScript files for your project. There are two ways plugman/Cordova automatically include JavaScript files for plugins. You need to check the `plugin.xml` file for each plugin you install to see which method they use:

* The `<asset>` element just includes the plugin's JavaScript file in your app. The file won't show up in the project structure, but will be available on the device. You need to manually include a `<script>` tag in your HTML to load the JavaScript file.
* The `<js-module>` element both includes the plugin's JavaScript file and also injects the relevant `<script>` tag into the DOM of all WebViews.

Thus, if your plugins use the `<asset>` element, you need to remove any plugin-specific JavaScript files from your project, and ensure that any `<script>` tags load the files from the correct path.

If your plugins use the `<js-module>` element, then you need to both remove any plugin-specific JavaScript files as well as any `<script>` tags – everything is done automatically.

A properly coded Cordova plugin should not execute any code on load, but wait for an `init()` call or similar, so there's no harm in having the `<script>` tag injected to each view.
