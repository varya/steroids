---
layout: post
title:  "Building your app for Android"
date:   2013-05-21 13:51:34
categories: cloud_services
platforms: Android
---

### Related Guides
* [Configuring custom plugins for your app][custom-plugin-config]

The AppGyver Build Service lets you create an APK package of your application that you can distribute either ad hoc or submit to Google Play. 

All Android application builds need to be signed with a suitable private key, stored in a `.keystore` file. You can use the same private key for multiple apps. When you upload an app to Google Play, all future updates to that app require your private key.

**If you lose the `.keystore` file bound to your app on Google Play, there's no way to update your app anymore, so keep it safe!**

## Generating a .keystore file

The `keytool` command comes bundled with the [Android SDK][android-sdk] and [Xcode][xcode] Command Line Tools – install either one, if you haven't already.

Next up, you need to obtain a suitable private key. The Android develeper portal article on signing your application has a section on [obtaining a suitable private key][android-dev-cert] that has more robust information, but basically, you need to run the following command in a Terminal window:

```
$ keytool -genkey -v -keystore my-app-name.keystore -alias my_keystore_alias
-keyalg RSA -keysize 2048 -validity 10000
```

This will start generating a RSA-encrypted, 2048 bit keypair with a validity of 10,000 days.

1. You will be first prompted for a password. Enter something you'll remember.
2. You'll then be prompted for a bunch of personal information, like your first and last name and your organization. You can leave all these empty.
3. Finally, you're asked for a password for your keystore alias. You can just press enter to use the same password as for the keystore itself.

As a result, you get a `my-app-name.keystore` file, which you'll be uploading momentarily to the AppGyver Build Service.

It's a good pattern to use a unique `.keystore` file for every app you have, although nothing stops you from using the same file for multiple apps. Remember, if you lose the `.keystore` file, you can't update the associated apps on Google Play anymore.

## Using the AppGyver Build Service

Now that you have the `.keystore` file, we can build your APK.

First, you need to create a cloud-deployed build of your app. You can do this with `$ steroids deploy` in your project folder. See the [cloud deployment guide][cloud-deploy] for more information.

After you have deployed your app to the cloud, you need to set up a bunch of options so that we can build your app properly. Go to [cloud.appgyver.com][appgyver-cloud], click on your app and then on the Configure Build Settings button.

Let's go through what you need to do in each section.

### Keystore

* Upload your Android `.keystore` file, the one you just generated.
* Enter your keystore password.
* Enter your keystore alias.
* Enter your keystore alias password.

### Production Build and Ad Hoc Build

Note that Android doesn't distinguish between production and ad hoc builds. The different build types are so that you can easily have two versions of your app installed on the same device, with different names and package identifiers.

For example, if you have published your app to Google Play or some other app store, you might want to keep a separate development version on the side via Ad Hoc Build, so you don't have to overwrite your latest stable store release.

For both Production and Ad Hoc Build, you need to enter:

* Display Name for your app. This name will be shown under your app's icon on the device. Around 20 characters is a good length.
* Package Identifier for your app. This must be a reverse-domain, Java-language-style package name, e.g. `com.phoenixfoundation.macgyverapp` (or `com.phoneixfoundation.macgyvertest` for an Ad Hoc build). You can use letters, numbers and underscores, but individual package name parts must start with letters. Don't use the `com.example` namespace when publishing your app. The package name has to have at least two parts, i.e. just `myappname` won't work but `com.myappname` will.
* Version Code. This is an internal version number, set as an integer, e.g. "100". Each successive version of your app must have a higher Version Code.
* Version Number. The version number shown to users, e.g. "1.0".

### Scanner build

The Scanner Build is a special build of your application intended for development with the Steroids npm. It allows you to create a Scanner app that includes the custom plugins defined in the plugins field. As such, a Scanner Build doesn't show your actual application, but rather lets you scan a QR code to connect to a computer running the Steroids server.

### Plugins

See the [custom plugins config guide][custom-plugin-config] for more information on using custom plugins with your app.

### Shared Settings

Set the [Android orientation mode][android-dev-orientation] to one of the available options.

### Requested permissions

The usage permissions that your app will request from the user when it is installed. Disabling these can affect the functionality of Cordova API namespaces (e.g. disabling Camera will disable Cordova's `navigator.camera`).

### Icons

Different density icons for your app. Android apps should have icons with transparent backgrounds.

### Splashscreens

Different density splashscreens for your app. They should optimally be [NinePatch PNG images][android-dev-ninepatch], which is an Android-specific image format that allows defined sections of the image to be stretched without distorting the whole image. Read the above link for more information.

## Building your APK

After you're done, click Update Settings. Then, you can use the Build an Ad Hoc build and Build for Google Play buttons on the Build for Distribution tab to request a new build of your app.

Building the app takes a few moments, after which you'll get an e-mail with a link to the downloadable APK. You can also see your build history and download earlier builds by clicking on the Show Build History button.

[appgyver-cloud]: http://cloud.appgyver.com
[cloud-deploy]: /steroids/guides/steroids_npm/cloud-deploy/
[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[android-dev-cert]: http://developer.android.com/tools/publishing/app-signing.html#cert
[android-dev-ninepatch]: http://developer.android.com/guide/topics/graphics/2d-graphics.html#nine-patch
[android-dev-orientation]: http://developer.android.com/reference/android/R.attr.html#screenOrientation
[android-sdk]: http://developer.android.com/sdk/index.html
[xcode]: https://developer.apple.com/xcode/