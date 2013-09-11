---
layout: post
title:  "Using the integrated Facebook Connect plugin (iOS)"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS
---

### Related guides
* [Configuring custom plugins for your app][custom-plugin-config]

Note: the integrated Facebook Connect plugin is currently available for iOS only. For Android, any [plugman][plugman]-compatible Facebook Connect plugin should work.

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

Then, the part why you need a custom-built Scanner app: set the **Facebook URL Protocol** field to match your Facebook App ID, in the format `fb123412341234` where `123412341234` is your Facebook App ID.

*Note: also make sure your Scanner app's version is e.g. `2.7.7` (there's currently a bug in Steroids npm where the version number of custom-built Scanner apps is checked for validity, when the check should only be made for the store-downloaded Scanner app – we're working on fixing that).*

Finally, request a Scanner build, download it and install it on your device. (The Facebook Connect plugin is not usable via the Simulator at the moment.)

### 3: Set up your Steroids project

Download the [FacebookConnect.js](https://github.com/AppGyver/steroids-plugins/tree/master/FacebookConnect/www/FacebookConnect.js) file and add it to your Steroids project, in e.g. `www/plugins/FacebookConnect.js`. Add a `<script>` tag that loads the JS file.

The correct `<plugin>` tag is included by default in `www/config.ios.xml`:

{% highlight xml %}
<plugin name="FacebookConnect" value="FacebookConnect" />
{% endhighlight %}

Run `$ steroids connect` and scan the QR code with your custom-built Scanner. Now, you should have `window.plugins.facebookConnect` defined. The following CoffeeScript snippet defines a few example API calls:

{% highlight coffeescript %}
appId = 123412341234 # replace with your Facebook App ID
permissions = ["email", "user_about_me"] # replace with whatever permissions you need


login = ->
  window.plugins.facebookConnect.login(
    {permissions: ["email", "user_about_me"], appId: $scope.appId}
    (result)->
      alert("facebookConnect.login:" + JSON.stringify(result))
  )

requestWithGraphPath = ->
  window.plugins.facebookConnect.requestWithGraphPath "/me/friends", (result)->
    alert("facebookConnect.requestWithGraphPath:" + JSON.stringify(result))

logout = ->
    window.plugins.facebookConnect.logout (result)->
      alert("facebookConnect.logout:" + JSON.stringify(result))
{% endhighlight %}

Calling the `login()` function from your app should now switch to the Facebook app (or Facebook website, if the app is not installed) for login, after which Facebook API requests can be made.

You can see an example implementation in the [Steroids Kitchensink app](https://github.com/AppGyver/kitchensink) – just make sure to replace the Facebook App ID in `app/controllers/facebook.coffee` with your Facebook App ID.

## Limitations

The AppGyver Scanner app currently integrates a version of Oliver Louvigne's [Cordova Facebook Connect Plugin](https://github.com/mgcrea/cordova-facebook-connect). This plugin is somewhat outdated, and we are in the process of upgrading to the current [official Facebook plugin](https://github.com/phonegap/phonegap-facebook-plugin).

As a result of the plugin implementing an older version of the Facebook API, limiting Graph queries or trying to display a Facebook Dialog cause the app to crash. Login and basic Graph queries work fine though.

[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[ios-build-config]: /steroids/guides/cloud_services/ios-build-config/
[plugman]: https://github.com/apache/cordova-plugman