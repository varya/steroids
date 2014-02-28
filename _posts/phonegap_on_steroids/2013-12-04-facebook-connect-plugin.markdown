---
layout: post
title:  "Using the official Facebook plugin"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS, Android
---

### Related guides
* [Configuring custom plugins for your app][custom-plugin-config]

The Steroids-supported way to use the official Facebook plugin is to use [Steroids Add-ons](http://www.appgyver.com/steroids/addons). To use the Facebook plugin without the Facebook Add-on, refer to the documentation on the [plugin's GitHub Page](https://github.com/phonegap-build/FacebookConnect), though note that we only offer support for users using the Facebook plugin via the Steroids Facebook Add-on.

However, to help you get started, we've included below instructions on how to configure your app in Facebook's Developer portal, and how to create a custom build that has the Facebook plugin included.

## Configuring your Facebook App

Go to [developers.facebook.com/apps](https://developers.facebook.com/apps/). If you don't already have an app, select **Apps** > **Create an app**. Fill in the required information. Once your Facebook app is created, select **Settings** from the left-hand navigation.

### iOS

Click **Add Platform** and select **iOS**. Enter the proper config options:

* **Bundle ID of your app:** The Bundle ID must match the one you enter into the Build Service in Step 2 – if you don't know your custom Scanner's bundle ID yet, input something like `com.mycompany.facebooktest.scanner`.
* If you don't know your **iPhone App Store ID** and **iPad App Store ID** yet, you can input `0` in both fields.
* Remember to enable the **Single Sign On** option.

Now your Facebook App is configured to accept login requests from iOS apps with the given Bundle ID.

### Android

Proper guide for Android setup is coming soon. In the meanwhile, you can take a look at [Facebook's Android Getting Started Guide](https://developers.facebook.com/docs/android/getting-started/), which has all the necessary information.

### Making your app publicly available

Then, open the **Status & Review** page from the left-hand navigation. Set the **Do you want to make this app and all its live features available to the general public?** option to **Yes**.

## Including the Facebook plugin

If you haven't already, use `$ steroids deploy` to deploy your app to the AppGyver Cloud. Then, go to [cloud.appgyver.com](http://cloud.appgyver.com), open your deployed app and follow the instructions in the [iOS Build Configuration guide][ios-build-config].

You only need a Scanner build for now, so set that up. Make sure your Scanner app has a **Bundle Identifier** (iOS) or **Pacakge Identifier** (Android) that matches the one you entered in your Facebook App's configuration page.

Then, find the **Plugins** field and include the Facebook plugin's GitHub repo with your app's Facebook App ID and App name:

{% highlight javascript %}
[
  {
    "source":"https://github.com/phonegap-build/FacebookConnect.git",
    "variables": {
      "APP_ID":"123412341234",
      "APP_NAME":"my-application"
    }
  }
]
{% endhighlight %}

Finally, request a Scanner build, download it and install it on your device. (The Facebook Plugin is not usable via the Simulator at the moment.)

Once you want to test a stand-alone version of your app, you can simply add the configurations for an Ad Hoc or App Store build – the plugin works the same.

## Known issues

Since there is just a global Plugins field in the Build Config page, building e.g. a Scanner build and an Ad Hoc build will cause both apps to have the same App ID in their `Info.plist`/`AndroidManifest.xml` file (generated automatically by the Build Service). This can cause Facebook to return to the wrong app after logging in.

A workaround is to update the settings so that only the build type you're working with at the moment (e.g. Scanner or Ad Hoc) will have the correct Facebook App ID field set when building, and have the field empty for the other build type. Alternatively, you can have two different Facebook Apps for the two different build types, though you still have to change the Facebook App ID field in the Build Service manually between builds.

[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[plugman]: https://github.com/apache/cordova-plugman
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
