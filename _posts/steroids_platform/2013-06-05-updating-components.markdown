---
layout: post
title:  "Updating Steroids components"
date:   2013-05-21 13:51:34
categories: steroids_platform
platforms: iOS, Android
---

This guide explains how to keep all components in the Steroids platform up-to-date. For maximum compatibility

##Updating the Steroids npm

To update the Steroids `npm`, run this in a Terminal window:

<pre class="terminal">
$ npm update steroids -g
</pre>

This will check for the latest version and update it if needed. The `-g` option sets the update to affect your global Steroids install.

*If you are running a non-NVM-installed version of Node.js and `npm`, you'll probably need to write `$ sudo npm update steroids -g` for the update to run correctly.*

The Steroids `npm` keeps its integrated iOS Simulator app automatically updated to the latest version.

##Updating Steroids.js in your project

To update your project's Steroids.js to the latest version, update the Steroids `npm` first. After this, go to your project folder and run:

<pre class="terminal">
$ steroids update
</pre>

This will update Steroids.js and other libraries according to your project's `config/bower.json` component dependency list.

Note that the `config/application.coffee` file cannot be updated automatically for existing projects. If a Steroids `npm` update introduces new properties to `config/application.coffee` (mentioned in the release notes), they will need to be copied over from a fresh project.

##Updating AppGyver Scanner

AppGyver Scanner is updated via App Store or Google Play:

* [AppGyver Scanner for iOS in App Store][app-store]
* [AppGyver Scaner for Android in Google Play][google-play]

[app-store]: https://itunes.apple.com/app/appgyver-scanner/id575076515?mt=8
[google-play]: https://play.google.com/store/apps/details?id=com.appgyver.android