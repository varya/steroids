---
layout: post
title:  "Using the official Facebook plugin"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS, Android
---

### Related guides
* [Configuring custom plugins for your app][custom-plugin-config]

To use the [official Cordova Facebook plugin](https://github.com/phonegap-build/FacebookConnect), you need to configure your Facebook app in [developers.facebook.com](https://developers.facebook.com), build a custom Scanner app via the [Build Service](http://cloud.appgyver.com) and then load the automatically included JavaScript files in your project via a `<script>` tag.

## 1: Configure your Facebook App

In the [developers.facebook.com](https://developers.facebook.com) page of your app, click **Edit** in the upper-right corner.

### iOS

You need to enable the **Native iOS App** integration option by clicking on the box. Then

* Fill in the **Bundle ID** of your app. The Bundle ID must match the one you enter into the Build Service in Step 2 – if you don't know your custom Scanner's bundle ID yet, input something like `com.mycompany.facebooktest.scanner`.
* If you don't know your **iPhone App Store ID** and **iPad App Store ID** yet, you can input `0` in both fields.
* Enable the **Facebook Login** option.
* Click **Save Changes**.

Now your Facebook App is configured to accept login requests from iPhone apps with the given Bundle ID.

### Android

A more detailed guide on Android setup is coming up soon. In the meantime, read through Facebook's [official Android SDK setup guide](https://developers.facebook.com/docs/android/getting-started/) to get started.

## 2: Build a custom Scanner app

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

*Note: also make sure your Scanner app's version is e.g. `3.1.0` (there's currently a bug in Steroids CLI where the version number of custom-built Scanner apps is checked for validity, when the check should only be made for the store-downloaded Scanner app – we're working on fixing that).*

Finally, request a Scanner build, download it and install it on your device. (The Facebook Plugin is not usable via the Simulator at the moment.)

### 3: Set up your Steroids project

The plugin JavaScript files will be included automatically to your build. Just add the necessary `<script>` tags in your HTML to load the JS files:

{% highlight html %}
<script src="http://localhost/cdv-plugin-fb-connect.js"></script>
<script src="http://localhost/facebook-js-sdk.js"></script>
{% endhighlight %}

Now, we'll initialize the Facebook plugin via the Facebook JavaScript SDK:

{% highlight javascript %}
FB.init({
  appId: 123412341234,
  nativeInterface: CDV.FB
})
{% endhighlight %}

The `appId` field must match your Facebook App ID. By passing the Corodva Facebook plugin object `CDV.FB` as `nativeInterface`, we overwrite certain Facebook JavaScript SDK functionalities with native ones, e.g. logins and dialogs.

This doesn't do much, so let's add a login function:

{% highlight javascript %}
function login() {
  FB.login(function(response) {
    if (response.session) {
      console.log('Welcome!  Fetching your information.... ');
      FB.api('/me', function(response) {
        alert('Good to see you, ' + response.name + '.');
      });
    } else {
      console.log('User cancelled login or did not fully authorize.');
    }
  });
}
{% endhighlight %}

Run `$ steroids connect` and scan the QR code with your custom-built Scanner.

Calling the `login()` function from your app should now switch to the Facebook app (or Facebook website, if the app is not installed) for login, after which Facebook API requests can be made.

## Kitchensink Example

You can see a more robust example implementation in the [Steroids Kitchensink app][kitchensink] – just make sure to replace the Facebook App ID in `app/controllers/facebook.coffee` with your Facebook App ID.

## Known issues

Since there is just a global Plugins field in the Build Config page, building e.g. a Scanner build and an Ad Hoc build will cause both apps to have the same App ID in their `Info.plist`/`AndroidManifest.xml` file (generated automatically by the Build Service). This can cause Facebook to return to the wrong app after logging in.

A workaround is to update the settings so that only the build type you're working with at the moment (e.g. Scanner or Ad Hoc) will have the correct Facebook App ID field set when building, and have the field empty for the other build type. Alternatively, you can have two different Facebook Apps for the two different build types, though you still have to change the Facebook App ID field in the Build Service manually between builds.

[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[plugman]: https://github.com/apache/cordova-plugman
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
[kitchensink]: https://github.com/appgyver/kitchensink/
