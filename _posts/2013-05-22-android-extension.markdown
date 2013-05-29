---
layout: post
title:  "Using the .android extension"
date:   2013-05-21 13:51:34
categories: 
platforms: android
---

**Supported Platforms: Android**

When you are developing your app for both iOS and Android, there are some situations where it becomes difficult to use the same files for both platforms. Perhaps you'd like to use a different background image for your app on Android, or you have an HTML dialogue box that should use different CSS based on the platform.

Instead of using JavaScript to detect the user agent and manipulate your code dynamically to circumvent these issues, Steroids allows you to simply create a copy of any project file and add the `.android` extension to it.

On Android devices, the version of the file with the `.android` extension will be used instead of the original file. On iOS, the `.android` file will be ignored and the original file will be used. It's as simple as that.

<div class="alert" markdown="1">
There is currently a known issue where `.android` files are cached permanently on the device, though they are still replaced by newer versions of the same file. Thus, if you create an `index.html.android` file and push the changes to your Android device, the regular `index.html` file will not be loaded, even if you delete the `index.html.android` file. Instead, the cached version of `index.html.android` will be used until you push a newer version of the file to your device.
</div>
