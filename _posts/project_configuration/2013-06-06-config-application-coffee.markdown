---
layout: post
title:  "Steroids preferences in config/application.coffee"
date:   2013-05-21 13:51:34
categories: project_configuration
platforms: iOS, Android
---

###Related guides
* [Cordova preferences in config.xml (Android)][config-xml-android-guide]
* [Cordova preferences in config.xml (iOS)][config-xml-ios-guide]

Your Steroids app is configured via the file `config/application.coffee`. The file is written in [CoffeeScript][coffeescript] for better readability and nicer commenting. Notice that CoffeeScript is picky about tab spaces, so when uncommenting lines make sure that no extra spaces or tabs are left behind.

Configuring your app consists of simply setting properties of the `steroids.config` object.

The default values below are the ones that are passed to the Steroids runtime if the property in question cannot be found. The actual result (e.g. in the case of color values) can be different.

*Note that Cordova's config.xml file also configures certain app-wide settings.*

##steroids.config.name

*Required.*

Specifies the name of the application. This name will be used in AppGyver Cloud Services for your [cloud-deployed][cloud-deploy-guide] app (the app store display name will be set separately when you build a distribution package of your app).

{% highlight coffeescript %}
steroids.config.name = "Hello World"
{% endhighlight %}


##steroids.config.location

*Required.*

This defines the initial HTML document that will be loaded and shown when the application starts. Filenames are relative to the `dist/` folder, which is generated in the project's root during `steroids make`. This value can be configured to be any URL.

*Note that Steroids doesn't use Cordova's `<content>` preference in config.xml to set up the initial location of the app.*

{% highlight coffeescript %}
steroids.config.location = "index.html"
{% endhighlight %}

###Examples of valid values:

* `steroids.config.location = "filename.html"` – served with File URL, like in PhoneGap.
* `steroids.config.location = "http://localhost/filename.html"` – served from the device's web server.
* `steroids.config.location = "http://www.google.com"` – any external URL.

##steroids.config.hosts

*Default:* `[]`

Defines the hostnames that the application will capture, given as an array of strings.

Requests by the Steroids runtime to a captured hostname will be served from localhost. For example, if you have defined `mobileapp.example.com` as one of your captured hosts, you can load the document at `www/index.html` equivalently from both `http://localhost/index.html` and `http://mobileapp.example.com/index.html`. The only difference is the WebView's document location (e.g. `window.location.href`).

This is useful for circumventing same origin issues. With the above example, AJAX connections to your backend at `api.example.com` are allowed, because to remote locations, the Steroids app (`mobileapp.example.com`) appears to be loaded from the same top-level domain (`*.example.com`).

{% highlight coffeescript %}
steroids.config.hosts = ["mobileapp.example.com", "m.example.net"]
{% endhighlight %}

##steroids.config.tabBar

This property configures the native tab bar.

###steroids.config.tabBar.enabled

*Default:* `false`

Enables the native tab bar in the application. Overrides the `steroids.config.location` property. Requires that `steroids.config.tabBar.tabs` contains at least one tab.

{% highlight coffeescript %}
steroids.config.tabBar.enabled = true
{% endhighlight %}

###steroids.config.tabBar.tabs

*Default:* `[]`

An array of tab objects that specifies the tabs shown in the app's native tab bar. Requires `steroids.config.tabBar.enabled` to be `true`

A tab object contains the following proporties:

- `title`: text shown in the tab title. **Required.**
- `icon`: path to the tab's icon file, relative to `dist/` (e.g. `icons/pill@2x.png`). *Tab bar icons are supported by iOS only.*
  - if you add `@2x` before the file extension (like in the above example), iOS will scale down the image to 50% size while keeping the amount of pixels the same. This allows the image to be displayed properly on Retina displays.
  - the correct size for a Retina tab bar icon is about 60x60 pixels (maximum 96x64 pixels)
- `location`: defines which HTML document the tab renders. **Required.** Examples of valid values are:
  - `"index.html`" – served with File URL, like in PhoneGap.
  - `"http://localhost/index.html"` – served from the device's web server.
  - `"http://www.google.com"` – any external URL.
<br>
<br>
{% highlight coffeescript %}
steroids.config.tabBar.tabs = [
  {
    title: "Localhost"
    icon: "icons/pill@2x.png"
    location: "http://localhost/views/pills/index.html"
  },
  {
    title: "File URL"
    icon: "icons/shoebox@2x.png"
    location: "index.html"
  },
  {
    title: "Internet"
    icon: "icons/telescope@2x.png"
    location: "http://www.google.com"
  }
]
{% endhighlight %}

###Tab bar colors (iOS-only)

*Default for all attributes:* `""`

Tab bar color settings are application-wide and cannot be changed during runtime. Colors are defined as 6-character RGB hex strings with a leading #.

{% highlight coffeescript %} 
# Sets the tint of the whole tab bar
steroids.config.tabBar.tintColor = "#00aeef"
# Sets the title text color of a tab
steroids.config.tabBar.tabTitleColor = "#ffffff"
# Sets the title text shadow color of a tab
steroids.config.tabBar.tabTitleShadowColor = "#000000"
# Sets the tint of a selected tab
steroids.config.tabBar.selectedTabTintColor = "#11aeef"
{% endhighlight %}

### Selected tab background image (iOS-only)

*Default:* `""`

On iOS, you can set an indicator image to be shown behind the active tab's icon and title text. This is done with the property:

{% highlight coffeescript %}
steroids.config.tabBar.selectedTabBackgroundImage = "images/tab_bg@2x.png"
{% endhighlight %}

The path for the the icon is relative to the root of the `dist/` folder.

The icon can be bigger than the tab area, which will cause it to overflow the tab bar. The icon is always centered to the active tab.

If you add `@2` before the file extension (like in the above example), iOS will scale down the image to 50% size while keeping the amount of pixels the same. This allows the image to be displayed properly on Retina displays.

##steroids.config.navigationBar

Configures your app's native nagivation bar. The navigation bar is enabled for each WebView independently by calling `steroids.navigationBar.show()`.

###Navigation bar colors

*Default for all attributes:* `""`

Navigation bar color settings are application-wide and cannot be changed during runtime. Colors are defined as 6-character RGB hex strings with a leading #. Color settings are **iOS-only, limited support on Android.**

{% highlight coffeescript %}
# Set the tint, title text color and title text shadow color of the navigation bar
steroids.config.navigationBar.tintColor = "#00aeef" # works on Android also
steroids.config.navigationBar.titleColor = "#ffffff"
steroids.config.navigationBar.titleShadowColor = "#000000"
# Set the tint, title text color and title text shadow color of navigation bar buttons
steroids.config.navigationBar.buttonTintColor = "#363636"
steroids.config.navigationBar.buttonTitleColor = "#ffffff"
steroids.config.navigationBar.buttonShadowColor = "#000000"
{% endhighlight %}

## Loading screen color (Android-only)

*Default:* `""`

The color for the Android loading screen, shown around the [loading.png][loading-png-guide] image, is set with the following property:

{% highlight coffeescript %}
steroids.config.loadingScreen.tintColor = "#262626"
{% endhighlight %}

The color is defined as a 6-character RGB hex string with a leading #. The loading screen color setting is **Android-only**. On iOS, use [loading.html][loading-html-guide] instead.

## steroids.config.theme

*Default:* `"default"`

Set an overall theme for the application, affecting the navigation bar and tab bar colors. Setting individual color values for the tab bar and navigation bar overrides this setting. **iOS-only.**

{% highlight coffeescript %}
steroids.config.theme = "default"  # iOS default style
steroids.config.theme = "black"    # the other iOS default style
{% endhighlight %}

##steroids.config.statusBar (iOS-only)

*Default:* `false`

Configures the status bar at the top of the screen.

{% highlight coffeescript %}
steroids.config.statusBar.enabled = true
{% endhighlight %}

Sets the visibility of the [iOS status bar][apple-status-bar] at the top of the screen, showing the device's carrier, clock and battery status. Disabling the status bar increases the vertical space available for your application by 20 pixels.

## steroids.config.editor

*steroids.config.editor.cmd default:* `"subl"`

*steroids.config.editor.args default:* `["."]`

Sets the editor command that is used in the Steroids console (i.e. `steroids connect`) with commands `edit` and `e`. By default, the editor is set to Sublime Text (the command `subl`) and the current project base directory is given as an argument to the editor run command. Arguments are always given as an array.

{% highlight coffeescript %}
steroids.config.editor.cmd = "subl"
steroids.config.editor.args = ["."]
{% endhighlight %}

##steroids.config.hooks

*Defaults:* none

Sets up custom commands to run when making a Steroids build. The first hook is run before `steroids make`, the process where `app/` and `www/` folders are processed into the `dist/` folder.

{% highlight coffeescript %}
steroids.config.hooks.preMake.cmd = "echo"
steroids.config.hooks.preMake.args = ["running yeoman"]
{% endhighlight %}

The other hook is run right after `steroids make`, before running `steroids package`, the process that packages the app before sending it to client devices.

{% highlight coffeescript %}
steroids.config.hooks.postMake.cmd = "echo"
steroids.config.hooks.postMake.args = ["cleaning up files"]
{% endhighlight %}

Note that arguments are always given as an array.

[apple-status-bar]: https://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/MobileHIG/UIElementGuidelines/UIElementGuidelines.html#//apple_ref/doc/uid/TP40006556-CH13-SW29
[cloud-deploy-guide]: /steroids/guides/steroids_npm/cloud-deploy/
[coffeescript]: http://coffeescript.org
[config-xml-android-guide]: /steroids/guides/project_configuration/config-xml-android/
[config-xml-ios-guide]: /steroids/guides/project_configuration/config-xml-ios/
[loading-html-guide]: /steroids/guides/ios/loading-html/
[loading-png-guide]: /steroids/guides/android/loading-png/