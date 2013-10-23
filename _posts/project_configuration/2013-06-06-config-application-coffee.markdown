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

*Note that Cordova's config.xml file also configures certain app-wide settings. See the guides for `config.ios.xml` and `config.android.xml` in the Related guides section above.*

##steroids.config.name

*Required.*

Specifies the name of the application. This name will be used in AppGyver Cloud Services for your [cloud-deployed][cloud-deploy-guide] app (the app store display name will be set separately when you build a distribution package of your app).

{% highlight coffeescript %}
steroids.config.name = "Hello World"
{% endhighlight %}


##steroids.config.location

This defines the initial HTML document that will be loaded and shown when the application starts. Filenames are relative to the `dist/` folder, which is generated in the project's root during `steroids make`. This value can be configured to be any URL.

*Note that Steroids doesn't use Cordova's `<content>` preference in config.xml to set up the initial location of the app.*

{% highlight coffeescript %}
steroids.config.location = "index.html"
{% endhighlight %}

###Examples of valid values:

* `steroids.config.location = "filename.html"` – served via File URL, like in PhoneGap.
* `steroids.config.location = "http://localhost/filename.html"` – served from the device's web server.
* `steroids.config.location = "http://www.google.com"` – any external URL.

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
  - `"index.html`" – served via File URL, like in PhoneGap.
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

Tab bar color settings are application-wide and cannot be changed during runtime. Colors are defined as 6-character RGB hex strings with a leading #.

{% highlight coffeescript %}
# Sets the tint of the whole tab bar
steroids.config.tabBar.tintColor = "#00aeef"
# Sets the title text color of a tab
steroids.config.tabBar.tabTitleColor = "#ffffff"
# Sets the tint of a selected tab
steroids.config.tabBar.selectedTabTintColor = "#11aeef"
{% endhighlight %}

### Tab bar background image (iOS-only)

On iOS, you can set a background image for the tab bar that will be used throughout the application. Path is relative to the root of the `dist/` folder. Appending a `@2x` before the file extension makes Retina-resolution images scale down correctly. The correct height for a Retina-resolution tab bar is 98px. The background image will repeat horizontally to cover the entire tab bar.

{% highlight coffeescript %}
steroids.config.tabBar.backgroundImage = "images/tabs_background@2x.png"
{% endhighlight %}

### Selected tab background image (iOS-only)

On iOS, you can set an indicator image to be shown behind the active tab's icon and title text. This is done with the property:

{% highlight coffeescript %}
steroids.config.tabBar.selectedTabBackgroundImage = "images/tab_bg@2x.png"
{% endhighlight %}

The path for the the icon is relative to the root of the `dist/` folder.

The icon can be bigger than the tab area, which will cause it to overflow the tab bar. The icon is always centered on the active tab.

If you add `@2` before the file extension (like in the above example), iOS will scale down the image to 50% size while keeping the amount of pixels the same. This allows the image to be displayed properly on Retina displays.

##steroids.config.navigationBar

Configures your app's native nagivation bar. The navigation bar is enabled for each WebView independently by calling [steroids.view.navigationBar.show()][steroids.view.navigationBar.show].

###Navigation bar colors

Navigation bar color settings are application-wide and cannot be changed during runtime. Colors are defined as 6-character RGB hex strings with a leading #. Color settings are **iOS-only, limited support on Android.**

{% highlight coffeescript %}
# Set the tint and title text color color of the navigation bar
steroids.config.navigationBar.tintColor = "#00aeef" # works on Android also
steroids.config.navigationBar.titleColor = "#ffffff"
# Set the tint and title text color of navigation bar buttons
steroids.config.navigationBar.buttonTintColor = "#363636"
steroids.config.navigationBar.buttonTitleColor = "#ffffff"
{% endhighlight %}

###Navigation bar background images (iOS only)

You can set a global background image for the navigation bar that will be used throughout the application, for both the portrait and landscape modes. Path is relative to the root of the `dist/` folder. Appending a `@2x` before the file extension makes Retina-resolution images scale down correctly. The correct height for a Retina-resolution image is 88px for portrait mode and 64px for landscape mode. The background images will repeat horizontally to cover the entire navigation bar.

If the image height is greater than 88px/64px, it will extend under the status bar text, allowing you to e.g. have an opaque status bar for your app. The status bar height is 40px on Retina displays, so an image with height 128px/104px will cover the status bar exactly.

{% highlight coffeescript %}
steroids.config.navigationBar.portrait.backgroundImage = "images/portrait_navbar@2x.png"
steroids.config.navigationBar.landscape.backgroundImage = "images/landscape_navbar@2x.png"
{% endhighlight %}

## Loading screen color (Android-only)

The color for the Android loading screen, shown around the [loading.png][loading-png-guide] image, is set with the following property:

{% highlight coffeescript %}
steroids.config.loadingScreen.tintColor = "#262626"
{% endhighlight %}

The color is defined as a 6-character RGB hex string with a leading #. The loading screen color setting is **Android-only**. On iOS, use [loading.html][loading-html-guide] instead.

##steroids.config.statusBar (iOS-only)

Configures the [iOS status bar][apple-status-bar] at the top of the screen.

### steroids.config.statusBar.enabled

*Default:* `false`

{% highlight coffeescript %}
steroids.config.statusBar.enabled = true
{% endhighlight %}

Sets the visibility of the status bar at the top of the screen, showing the device's carrier, clock and battery status. Disabling the status bar increases the vertical space available for your application by 20 pixels.

### steroids.config.statusBar.style

*Default:* `"default"`

{% highlight coffeescript %}
steroids.config.statusBar.style = "default"
{% endhighlight %}

Sets the style of the status bar on iOS. Available values are `"default"` and `"black"`.

##steroids.config.hosts

*Default:* none

Defines the hostnames that the application will capture, given as an array of strings.

Requests by the Steroids runtime to a captured hostname will be served from `localhost`. For example, if you have defined `mobileapp.example.com` as one of your captured hosts, you can load the document at `www/index.html` equivalently from both `http://localhost/index.html` and `http://mobileapp.example.com/index.html`. The only difference is how the WebView reports its document location (i.e. `window.location.href`).

This is useful for circumventing same origin issues. With the above example, AJAX connections to your backend at `api.example.com` are allowed, because to remote locations, the Steroids app (`mobileapp.example.com`) appears to be loaded from the same top-level domain (`*.example.com`).

{% highlight coffeescript %}
steroids.config.hosts = ["mobileapp.example.com", "m.example.net"]
{% endhighlight %}

*Note that hostname capturing only helps with outgoing requests. Incoming responses are likely to be blocked by WebKit, unless the [CORS headers][w3c-cors] (namely `Access-Control-Allow-Origin`) are set correctly.*


## steroids.config.watch

*Default:* none

{% highlight coffeescript %}
steroids.config.watch.exclude = ["www/my_excluded_file.js", "www/my_excluded_dir"]
{% endhighlight %}

When the Steroids `connect` console is run with the `--watch` option, changes to the files and directories listed in the exclude array will not trigger updates.

## steroids.config.hooks

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

## steroids.config.editor

*steroids.config.editor.cmd default:* `"subl"`

*steroids.config.editor.args default:* `["."]`

Sets the editor command that is used in the Steroids console (i.e. `steroids connect`) with commands `edit` and `e`. By default, the editor is set to Sublime Text (the command `subl`) and the current project base directory is given as an argument to the editor run command. Arguments are always given as an array.

{% highlight coffeescript %}
steroids.config.editor.cmd = "subl"
steroids.config.editor.args = ["."]
{% endhighlight %}

