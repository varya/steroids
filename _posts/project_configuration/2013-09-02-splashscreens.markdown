---
layout: post
title:  "Splashscreens"
date:   2013-05-20 13:51:34
categories: project_configuration
platforms: Android, iOS
---

### Related Guides
* [Building your app for Android][android-build-config]
* [Building your app for iOS][ios-build-config]

Application splashscreens are currently defined in the [AppGyver Cloud](http://cloud.appgyver.com) Build Service, separately for each cloud-deployed application. When you build a new Ad Hoc or App Store build, the uploaded custom splashscreens will be used instead of the default AppGyver splashscreen. If you build a custom Scanner build, the custom splashscreen will be used also when loading an application by scanning a QR code.

There is currently no way to set up a custom splashscreen for a Steroids project without using the Cloud Build Service. In the current Steroids app architecture, the splashscreens are set up when the app binary is built, and thus cannot be changed dynamically for apps loaded with the store-downloaded AppGyver Scanner.

See the [Android][android-build-config] and [iOS][ios-build-config] Build Configuration guides for more information on setting up the splashscreens.

## Android gotchas

On Android, the  [onPageFinished()](http://developer.android.com/reference/android/webkit/WebViewClient.html#onPageFinished) event is the one that causes the splashscreen to hide. This can cause a black screen to briefly show before the initial HTML page is shown. This will be fixed by the [Fresh Android splashscreen implementation](https://github.com/AppGyver/steroids/issues/159).

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/