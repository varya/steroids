---
layout: post
title:  "Using the integrated Facebook plugin (iOS)"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS
---

### Related guides
* [Configuring custom plugins for your app][custom-plugin-config]

Note: the integrated Facebook plugin is currently available for iOS only. For Android, any [plugman][plugman]-compatible Facebook plugin should work.

## Usage

To use the integrated Facebook plugin, you need to configure your Facebook app, build a custom Scanner app and load the plugin JavaScript file in your project.

### 1: Configure your Facebook App

In the [developers.facebook.com](https://developers.facebook.com) page of your app, click **Edit** in the upper-right corner. You then need to enable the **Native iOS App** integration option by clicking on the box. Then

* Fill in the **Bundle ID** of your app. The Bundle ID must match the one you enter into the Build Service in Step 2 – if you don't know your custom Scanner's bundle ID yet, input something like `com.mycompany.facebooktest.scanner`.
* If you don't know your **iPhone App Store ID** and **iPad App Store ID** yet, you can input `0` in both fields.
* Enable the **Facebook Login** option.
* Click **Save Changes**.

Now your Facebook App is configured to accept login requests from iPhone apps with the given Bundle ID.

### 2: Build a custom Scanner app

If you haven't already, use `$ steroids deploy` to deploy your app to the AppGyver Cloud. Then, go to [cloud.appgyver.com](http://cloud.appgyver.com), open your deployed app and follow the instructions in the [iOS Build Configuration guide][ios-build-config].

You only need a Scanner build for now, so set that up. Make sure your Scanner app has a **Bundle ID** that matches the one you entered in your Facebook App's configuration page.

Then, the part why you need a custom-built Scanner app: set the **Facebook URL Protocol** field to match your Facebook App ID – numbers only, e.g. `123412341234`

*Note: also make sure your Scanner app's version is e.g. `2.7.8` (there's currently a bug in Steroids CLI where the version number of custom-built Scanner apps is checked for validity, when the check should only be made for the store-downloaded Scanner app – we're working on fixing that).*

Finally, request a Scanner build, download it and install it on your device. (The Facebook Plugin is not usable via the Simulator at the moment.)

### 3: Set up your Steroids project

Download the necessary [JavaScript files](https://github.com/AppGyver/steroids-plugins/tree/master/FacebookConnect/www/) file and add them to your Steroids project, in e.g. the `www/plugins/` directory. Both files are needed. Add `<script>` tags to load the JS files.

The correct `<plugin>` tag is included by default in `www/config.ios.xml`, but if your project was created with an older version of Steroids CLI, ensure that it is correct:

{% highlight xml %}
<plugin name="org.apache.cordova.facebook.Connect" value="FacebookConnectPlugin" />
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
    if (response.authResponse) {
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

[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[plugman]: https://github.com/apache/cordova-plugman
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
[kitchensink]: https://github.com/appgyver/kitchensink/
