---
layout: post
title:  "App permissions"
date:   2013-05-21 13:51:34
categories: android
platforms: Android
---

### Related guides
* [Building your app for Android][android-build-config]

## Why does the Android Scanner request so many permissions?

The Scanner downloads the HTML5 files of your Steroids project from the locally running Steroids server (or from the cloud, in the case of a cloud-deployed app). When the app is running inside our runtime, the Cordova/Steroids.js JavaScript API calls are directed to the native layer, which then gives the user to access the Camera, Geolocation, Calendar (with plugin) etc.

These permissions are set before the app is compiled and can't be changed afterwards. Since the Scanner can't know which native functionalities it needs to be able to provide (since it needs to support all possible Steroids projects), it needs to ask for all the necessary permissions beforehand.

## Setting custom permissions

When you create an Ad Hoc or Distribution build of your app, you can choose which permissions it requests in the [Android build config page][android-build-config-permissions].

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[android-build-config-permissions]: /steroids/guides/cloud_services/android-build-config/#requested_permissions