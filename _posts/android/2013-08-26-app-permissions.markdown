---
layout: post
title:  "App permissions"
date:   2013-05-21 13:51:34
categories: android
platforms: Android
---

### Related guides
* [Building your app for Android][android-build-config]

## Permissions required by AppGyver Scanner for Android

The following list can be useful if e.g. the AppGyver Scanner app is not installing on your Android. You can use the [Android Developer Tool's](http://developer.android.com/tools/help/adb.html) "list features" and "list permissions" commands to see if some permissions are missing from your device.

Some of the permissions depend on further features, so the list is not completely exhaustive.

<pre class="terminal">
&lt;uses-permission android:name="android.permission.INTERNET"/&gt;
&lt;uses-permission android:name="android.permission.CAMERA"/&gt;
&lt;uses-permission android:name="android.permission.WRITEEXTERNALSTORAGE"/&gt;
&lt;uses-permission android:name="android.permission.ACCESSNETWORKSTATE"/&gt;
&lt;uses-permission android:name="android.permission.VIBRATE" android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.ACCESSCOARSELOCATION" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.ACCESSFINELOCATION" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.ACCESSLOCATIONEXTRACOMMANDS" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.READPHONESTATE" /&gt;
&lt;uses-permission android:name="android.permission.RECEIVESMS" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.RECORDAUDIO" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.RECORDVIDEO" /&gt;
&lt;uses-permission android:name="android.permission.MODIFYAUDIOSETTINGS" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.READCONTACTS" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.WRITECONTACTS" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.GETACCOUNTS" /&gt;
&lt;uses-permission android:name="android.permission.BROADCASTSTICKY" /&gt;
&lt;uses-permission android:name="android.permission.READCALENDAR" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.WRITECALENDAR" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.WAKELOCK" 
  android:required="false"/&gt;
&lt;uses-permission android:name="android.permission.READLOGS"/&gt;
&lt;uses-permission android:name="android.permission.GET_TASKS"/&gt;
&lt;uses-feature android:name="android.hardware.camera"/&gt;
&lt;uses-feature android:name="android.hardware.camera.autofocus" 
  android:required="false"/&gt;
&lt;uses-feature android:name="android.hardware.telephony" 
  android:required="false" /&gt;
</pre>

## Why does the Android Scanner request so many permissions?

The Scanner downloads the HTML5 files of your Steroids project from the locally running Steroids server (or from the cloud, in the case of a cloud-deployed app). When the app is running inside our runtime, the Cordova/Steroids.js JavaScript API calls are directed to the native layer, which then gives the user to access the Camera, Geolocation, Calendar (with plugin) etc.

These permissions are set before the app is compiled and can't be changed afterwards. Since the Scanner can't know which native functionalities it needs to be able to provide (since it needs to support all possible Steroids projects), it needs to ask for all the necessary permissions beforehand.

## Setting custom permissions

When you create an Ad Hoc or Distribution build of your app, you can choose which permissions it requests in the [Android build config page][android-build-config-permissions].

[android-build-config]: /steroids/guides/cloud_services/android-build-config/
[android-build-config-permissions]: /steroids/guides/cloud_services/android-build-config/#requested_permissions