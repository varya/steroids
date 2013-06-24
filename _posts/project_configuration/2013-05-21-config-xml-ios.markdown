---
layout: post
title:  "Cordova preferences in config.xml (iOS)"
date:   2013-05-20 13:51:34
categories: project_configuration
platforms: iOS
---

###Related Guides
* [Cordova preferences in config.xml (Android)][config-xml-android-guide]

Like Cordova, Steroids uses a `config.xml` file to set universal preferences for WebViews in your app, manage which Cordova plugins are loaded and set whitelisted domains for your app. The structure of `config.xml` is based on the [W3C Packaged Web Apps (Widgets)][widgets] specification, although only a limited set of the available elements are used.

The iOS-specific `config.xml` is located at `www/config.ios.xml`. (A `config.xml` file in the same directory overrides the platform-specific version.)

##Configuring preferences

Steroids supports configuring certain preferences for your WebViews. The preferences are set up universally for all `steroids.views.WebView` views in your app. Preferences are set up with `<preference>` elements:

{% highlight html %}
<preference name="DisallowOverscroll" value="false" />
{% endhighlight %}

The following preferences are supported by Steroids:

* **AllowInlineMediaPlayback (boolean, defaults to false)** - when set to true, inline HTML5 video playback is allowed on the iPhone (HTML5 videos are normally opened in a native video dialogue). Note that the `<video>` elements in the HTML document must also include the `webkit-playsinline="true"` attribute. On iPad, this preference is ignored and all HTML5 video files are always played inline. (Inline audio playback works on both devices regardless of this preference.)

* **DisallowOverscroll (boolean, defaults to false)** – when set to true, WebViews won't "rubber-band" back to place if the user scrolls past their edge (instead, the WebView will just stay in place).

* **EnableViewportScale (boolean, defaults to false)** - when set to true, a `<meta name="viewport">` tag affects viewport scaling. This also means that you need to set `user-scalable=no` in the `content` attribute of the meta tag to disable pinch-to-zoom. <br><br>Example:
  
{% highlight html %}
<meta name="viewport" content="user-scalable=no, initial-scale=1, width=device-width, 
height=device-height, target-densitydpi=device-dpi">
{% endhighlight %}
<br>

* **HideKeyboardFormAccessoryBar (boolean, defaults to false)** – when set to true, the additional toolbar on top of the keyboard is hidden (the one with the Prev, Next and Done buttons). Note that this means you need to use JavaScript to call `blur()` on the focused `<input>` element to dismiss the keyboard (since the Done button is hidden).

* **KeyboardDisplayRequiresUserAction (boolean, defaults to true)** – when set to false, the keyboard will open when an `<input>` element gets focus via the JavaScript `focus()` call. Otherwise, a user tap on the element is required to open the keyboard.

* **KeyboardShrinksView (boolean, defaults to false)** – when set to true to, the actual WebView is shrunk when the keyboard comes up, instead of the viewport shrinking and the WebView becoming scrollable. *Known issue: a yellow background flashes when the WebView is beign resized. A yellow background shows through the transparent form accessory bar.*

* **SuppressesIncrementalRendering (boolean, defaults to false)** – when set to true, the WebView suppresses content rendering until it is fully loaded into memory (this affects e.g. complex iframes). Note that by default, Steroids displays the `loading.html` screen until a new WebView has finished loading.


The following Cordova preferences are disabled due to Steroids using its own splashscreen implementation:

* **AutoHideSplashScreen**
* **FadeSplashScreen**
* **FadeSplashScreenDuration**
* **ShowSplashScreenSpinner**

The following Cordova preferences are currently nonfunctional in Steroids:

* **TopActivityIndicator (string, defaults to 'grey')** – valid values are 'grey', 'white' and 'whiteLarge'. Should change how the status bar spinner looks like. Currently disabled in Steroids.

* **MediaPlaybackRequiresUserAction (boolean, defaults to false)** – when set to true, should disable autoplaying of HTML5 videos. Currently autoplaying doesn't work in Steroids, regardless of this property.

* **BackupWebStorage (string, defaults to 'cloud')** – valid values are 'none', 'cloud' and 'local'. Should affect how web storage data is backed up. Currently disabled in Steroids.

##Configuring plugins

By removing `<plugin>` elements from the `config.xml` file, you can disable parts of Cordova. For more information on the API calls associated with each core plugin, see the [Steroids API docs][steroids-api].
  
###Geolocation plugin
The Geolocation plugin has a special `onload` attribute. By setting it to true, Steroids will start receiving geolocation data when the app initially loads, allowing for better GPS accuracy: 

{% highlight html %}
<plugin name="Geolocation" value="CDVLocation" onload="false"/>
{% endhighlight %}

##Domain whitelisting
The `<access>` element manages whitelisted domains for your app. For most cases, you are safe to allow all domains:
  
{% highlight html %}
<access origin="*" />
{% endhighlight %}

For more granular control, see the [Cordova Docs][cordova-domain-whitelisting] on the subjcet.

##App start location
The `<content>` tag is not used in Steroids to set the initial location of your app. Instead, the `steroids.config.location` property in `config/application.coffee` is used.
  
[widgets]: http://www.w3.org/TR/widgets/
[config-xml-android-guide]: /steroids/guides/project_configuration/config-xml-android/
[cordova-domain-whitelisting]: http://cordova.apache.org/docs/en/2.7.0/guide_whitelist_index.md.html#Domain%20Whitelist%20Guide
[steroids-api]: http://docs.appgyver.com