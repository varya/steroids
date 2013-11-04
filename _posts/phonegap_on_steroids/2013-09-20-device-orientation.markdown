---
layout: post
title:  "Setting allowed device orientations"
date:   2013-09-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS, Android
---

## Related Guides
* [Android Build Configuration][android-build-config]
* [iOS Build Configuration][ios-build-config]

By default, a Steroids project opened via the Scanner app runs in the portrait orientation only. There are two ways to change this behavior.

## JavaScript

The [steroids.view.setAllowedRotations][api-view-setAllowedRotations] API call allows you to override the default allowed device orientations, affecting the current view only. See the link for full API documentation.

## Custom Build

When you use our [Build Service][build-service] to create an Ad Hoc or App Store build of your app, you can set default allowed rotations for all views. For testing and development, you can also build a custom Scanner app that supports the rotations.

Note that the `steroids.view.setAllowedRotations` API call overrides these values.

### Android
In the [Android build configuration][android-build-config] page, the **Shared Settings** section allows you to set the orientation mode for your app. See the [official documentation][android-dev-orientation] for an explanation of the values.

### iOS
In the [iOS build configuration][ios-build-config] page, the **Shared Settings** section has checkboxes for allowed rotations in both iPhone and iPad separately.
[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
[api-view-setAllowedRotations]: http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.view_view.setAllowedRotations.md.html#steroids.view.setAllowedRotationos
[build-service]: http://cloud.appgyver.com
[android-dev-orientation]: http://developer.android.com/reference/android/R.attr.html#screenOrientation
