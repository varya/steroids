---
layout: post
title:  "Using the .android. extension"
date:   2013-05-21 13:51:34
categories: android
platforms: Android
---

When you are developing your app for both iOS and Android, there are some situations where it becomes difficult to use the same files for both platforms. Perhaps you'd like to use a different background image for your app on Android, or you have an HTML dialogue box that should use different CSS based on the platform.

Instead of using JavaScript to detect the user agent and manipulate your code dynamically to circumvent these issues, Steroids allows you to simply create a copy of any project file and add the `.android.` extension to it, before the file's own extension. Thus, `stylesheets/alert_box.css` would become `stylesheets/alert_box.android.css`.

**Note that you need to serve your project from localhost (e.g. `http://localhost/index.html`) for the `.android.` file replacement to work (`confing.android.xml` is an exception).**

On Android devices, the version of the file with the `.android.` extension will be used instead of the original file. On iOS, the `.android.` file will be ignored and the original file will be used. It's as simple as that.

##Known cache issue

<div class="alert" markdown="1">
There is currently a known issue where `.android.` files are cached permanently on the device. Using `index.html` as an example, the issue occurs when you

1. create an `index.android.html` file,
2. push the changes to your Android device, and
3. delete the `index.android.html` file.

As a result of the issue, the cached version of `index.android.html` will still be served instead of the regular `index.html`.

There are two ways to circmuvent the issue: 

1. Pushing a newer version of `index.android.html` to your device will overwrite the cached file.
2. Going to your Android Settings > Apps > AppGyver Scanner and tapping Clear Cache will remove the cached `.android.` file.
</div>
