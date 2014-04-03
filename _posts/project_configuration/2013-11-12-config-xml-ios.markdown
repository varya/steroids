---
layout: post
title:  "iOS preferences in config.ios.xml"
date:   2013-11-12 13:51:34
categories: project_configuration
platforms: iOS
---

###Related Guides
* [Cordova preferences in config.xml (Android)][config-xml-android-guide]

Like Cordova, Steroids uses a `config.xml` file to set universal preferences for WebViews in your app, manage which Cordova plugins are loaded and set whitelisted domains for your app. The structure of `config.xml` is based on the [W3C Packaged Web Apps (Widgets)][widgets] specification, although only a limited set of the available elements are used.

The iOS-specific `config.xml` is located at `www/config.ios.xml` – the plain `www/config.xml` is used as a dummy to ensure project compatibility with [Cordova CLI](https://github.com/apache/cordova-cli).

## Migrating from a 2.7.x version

With Steroids CLI version 3.1.0, the `config.ios.xml` file has undergone some breaking changes, read the [migration guide](/steroids/guides/steroids-js/cordova-3-1-migration/) for more information. The easiest way to migrate is to create a new Steroids project with `steroids create` and then copy your preferences over to the new format.

## Default config.ios.xml

The default `www/config.ios.xml` looks like this:

{% highlight xml %}
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.appgyver.helloSteroids" version="2.0.0"
  xmlns="http://www.w3.org/ns/widgets">

    <name>Hello Steroids</name>
    <description>
        A sample Steroids application.
    </description>
    <author email="contact@appgyver.com" href="http://www.appgyver.com/steroids">
        AppGyver Steroids Team
    </author>
    <access origin="*" />
    <preference name="AllowInlineMediaPlayback" value="false" />
    <preference name="DisallowOverscroll" value="false" />
    <preference name="EnableViewportScale" value="false" />
    <preference name="HideKeyboardFormAccessoryBar" value="false" />
    <preference name="KeyboardDisplayRequiresUserAction" value="false" />
    <preference name="KeyboardShrinksView" value="false" />
    <preference name="SuppressesIncrementalRendering" value="false" />


    <preference name="PaginationMode" value="unpaginated"/>
    <preference name="PageLength" value="0"/>
    <preference name="PaginationBreakingMode" value="page"/>
    <preference name="GapBetweenPages" value="0"/>

    <preference name="EnablePopGestureRecognition" value="true" />
    <preference name="DisableTabBarUnselectedIconTintColor" value="false" />
    <preference name="AutoHideSplashScreen" value="true" />
</widget>
{% endhighlight %}

## widget root tag

The root of `config.ios.xml` should be a `<widget>` element with the `id`, `version` and `xmlns` attributes. They are not used by Steroids currently, but should be kept up-to-date to ensure future compatibility.

## Name, description and author

These fields are not used by Steroids at the moment, but it's good practice to fill them out.

##Configuring preferences

Steroids supports configuring certain preferences for your WebViews. The preferences are set up universally for all `steroids.views.WebView` views in your app. Preferences are set up with `<preference>` elements:

{% highlight html %}
<preference name="DisallowOverscroll" value="false" />
{% endhighlight %}

The following Cordova preferences are supported by Steroids:

* **AllowInlineMediaPlayback (boolean, defaults to false)** - when set to true, inline HTML5 video playback is allowed on the iPhone (HTML5 videos are normally opened in a native video dialogue). Note that the `<video>` elements in the HTML document must also include the `webkit-playsinline="true"` attribute. On iPad, this preference is ignored and all HTML5 video files are always played inline. (Inline audio playback works on both devices regardless of this preference.)

* **DisallowOverscroll (boolean, defaults to false)** – when set to true, WebViews won't "rubber-band" back to place if the user scrolls past their edge (instead, the WebView will just stay in place).

* **EnableViewportScale (boolean, defaults to false)** - when set to true, a `<meta name="viewport">` tag affects viewport scaling. This also means that you need to set `user-scalable=no` in the `content` attribute of the meta tag to disable pinch-to-zoom. <br><br>Example:

{% highlight html %}
<meta name="viewport" content="user-scalable=no, initial-scale=1,
  maximum-scale=1, minimum-scale=1,  target-densitydpi=device-dpi">
{% endhighlight %}
<br>

* **HideKeyboardFormAccessoryBar (boolean, defaults to false)** – when set to true, the additional toolbar on top of the keyboard is hidden (the one with the Prev, Next and Done buttons). Note that this means you need to use JavaScript to call `blur()` on the focused `<input>` element to dismiss the keyboard (since the Done button is hidden).

* **KeyboardDisplayRequiresUserAction (boolean, defaults to true)** – when set to false, the keyboard will open when an `<input>` element gets focus via the JavaScript `focus()` call. Otherwise, a user tap on the element is required to open the keyboard.

* **KeyboardShrinksView (boolean, defaults to false)** – when set to true to, the actual WebView is shrunk when the keyboard comes up, instead of the viewport shrinking and the WebView becoming scrollable. *Known issue: a yellow background flashes when the WebView is beign resized. A yellow background shows through the transparent form accessory bar.*

* **SuppressesIncrementalRendering (boolean, defaults to false)** – when set to true, the WebView suppresses content rendering until it is fully loaded into memory (this affects e.g. complex iFrames). Note that by default, Steroids displays the `loading.html` screen until a new WebView has finished loading.

* **PaginationMode (string, defaults to `unpaginated`)** - valid values are `unpaginated`, `leftToRight`, `topToBottom`, `bottomToTop`, and `rightToLeft`. This property determines whether content in the WebView is broken up into pages that fill the view one screen at a time, or shown as one long scrolling view. If set to a paginated form, this property toggles a paginated layout on the content, causing the web view to use the values of the `PageLength` and `GapBetweenPages` preferences to relayout its content.

* **PageLength (float, defaults to 0)** - the size of each page, in points, in the direction that the pages flow. When `PaginationMode` is right to left or left to right, this property represents the width of each page. When `PaginationMode` is topToBottom or bottomToTop, this property represents the height of each page. The default value is 0, which means the layout uses the size of the viewport to determine the dimensions of the page.

* **PaginationBreakingMode (string, defaults to `page`)** - valid values are `page` and `column`. The manner in which column- or page-breaking occurs. This property determines whether certain CSS properties regarding column- and page-breaking are honored or ignored. When this property is set to column, the content respects the CSS properties related to column-breaking in place of page-breaking.

* **GapBetweenPages (float, defaults to 0)** - the size of the gap, in points, between pages.

In addition, Steroids adds the following configuration options:

* **EnablePopGestureRecognition (boolean, defaults to true)** – when set to true, the back swipe gesture of iOS7 is disabled.

* **DisableTabBarUnselectedIconTintColor (boolean, defaults to false)** when set to true, the default color of the icon tint color of the unselected tab(s) in the native tab bar is disabled.

* **AutoHideSplashScreen (boolean, defaults to true)** – when set to true, the initial splashscreen is not hidden automatically in order to let the user hide it with `steroids.splashscreen.hide`, when approriate.

* **DisableDoubleTapToFocus (boolean, defaults to false)** – when set to true, double-tapping on a part of the WebView no longer scrolls the WebView to that position. Setting this to true also removes the 300ms delay with JavaScript `click` events.

* **ViewIgnoresStatusBar (boolean, defaults to false)** – when set to true, WebViews will start rendering from the top of the screen, instead of below the status bar. This makes the WebView background initially stretch to cover the whole screen, with the status bar rendered on top of the WebView.

The following Cordova preferences are disabled due to Steroids using its own splashscreen implementation:

* **FadeSplashScreen**
* **FadeSplashScreenDuration**
* **ShowSplashScreenSpinner**

The following Cordova preferences are currently nonfunctional in Steroids:

* **TopActivityIndicator (string, defaults to 'grey')** – valid values are 'grey', 'white' and 'whiteLarge'. Should change how the status bar spinner looks like. Currently disabled in Steroids.

* **MediaPlaybackRequiresUserAction (boolean, defaults to false)** – when set to true, should disable autoplaying of HTML5 video and audio. Currently autoplaying doesn't work in Steroids, regardless of this property.

* **BackupWebStorage (string, defaults to 'cloud')** – valid values are 'none', 'cloud' and 'local'. Should affect how web storage data is backed up. Currently disabled in Steroids.

##Domain whitelisting
The `<access>` element manages whitelisted domains for your app. For most cases, you are safe to allow all domains:

{% highlight html %}
<access origin="*" />
{% endhighlight %}

For more granular control, see the [Cordova Docs][cordova-domain-whitelisting] on the subjcet.

##App start location
The `<content>` tag is not used in Steroids to set the initial location of your app. Instead, the `steroids.config.location` property in `config/application.coffee` is used.

##Setting fullscreen mode
###(and other PhoneGap Build config.xml properties)
To hide the status bar (showing carrier, clock and battery status), set the `steroids.config.statusBar.enabled` to `false` in the [config/application.coffee][config-application-coffee] file.

`<preference name="fullscreen" value="true" />` and other PhoneGap Build preference tags are not supported by Steroids.

[widgets]: http://www.w3.org/TR/widgets/
[config-xml-android-guide]: /steroids/guides/project_configuration/config-xml-android/
[cordova-domain-whitelisting]: http://cordova.apache.org/docs/en/2.7.0/guide_whitelist_index.md.html#Domain%20Whitelist%20Guide
[steroids-api]: http://docs.appgyver.com
[config-application-coffee]: /steroids/guides/project_configuration/config-application-coffee/
