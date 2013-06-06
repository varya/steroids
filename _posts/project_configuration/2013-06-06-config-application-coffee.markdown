---
layout: post
title:  "Steroids preferences in config/application.coffee"
date:   2013-05-21 13:51:34
categories: project_configuration
platforms: iOS, Android
---

Your Steroids app is configured via the file `config/application.coffee`. The file is written in [CoffeeScript][coffeescript] for better readability and nicer commenting. Notice that CoffeeScript is picky about tab spaces, so when uncommenting lines make sure that no extra spaces or tabs are left behind.

Configuring your app consists of simply setting properties of the `steroids.config` object.

*Note that Cordova's [config.xml][config-xml-ios] file also configures certain app-wide settings.*

##steroids.config.name

Specifies the name of the application. This name will be used in AppGyver Cloud Services for your [cloud-deployed][cloud-deploy] app (the app store display name will be set separately when you build a distribution package of your app).

```
steroids.config.name = "Hello World"
```


##steroids.config.location

This defines the initial HTML document that will be loaded and shown when the application starts. Filenames are relative to the `dist/` folder, which is generated in the project's root during `steroids make`. This value can be configured to be any URL.

```
steroids.config.location = "index.html"
```

###Examples of valid values:

* `steroids.config.location = "filename.html"  # served with File URL, like in PhoneGap`
* `steroids.config.location = "http://localhost/filename.html"  # served from the device's web server`
* `steroids.config.location = "http://www.example.com"  # any external URL`

##steroids.config.hosts

Defines the hostnames that the application will capture, given as an array of strings.

Requests by the Steroids runtime to a captured hostname will be served from localhost. For example, if you have defined `mobileapp.example.com` as one of your captured hosts, you can load the document at `www/index.html` equivalently from both `http://localhost/index.html` and `http://mobileapp.example.com/index.html`. The only difference is the WebView's document location (e.g. `window.location.href`).

This is useful for circumventing same-origin issues. With the above example, AJAX connections to your backend at `api.example.com` are allowed, because to remote locations, the Steroids app (`mobileapp.example.com`) appears to be loaded from the same top-level domain (`*.example.com`).

```
steroids.config.hosts = ["mobileapp.example.com", "m.example.net"]
```

##steroids.config.tabBar

This property configures the native tab bar.

###steroids.config.tabBar.enabled

Enables the native tab bar in the application. Overrides the `steroids.config.location` property. Requires that `steroids.config.tabBar.tabs` contains at least one tab.

```
steroids.config.tabBar.enabled = true
```

###steroids.config.tabBar.tabs

An array of tab objects that specifies the tabs shown in the app's native tab bar. Requires `steroids.config.tabBar.enabled` to be `true`

A tab object contains the following proporties:

- `title`: text shown in the tab title. **Required.**
- `icon`: path to the tab's icon file, relative to `dist/` (e.g. `icons/pill@2x.png`). Tab bar icons are supported by iOS only.
  - adding '@2x' before the file extension in the icon's filename allows proper native-level handling of Retina images.
- `location`: defines which HTML document the tab renders. **Required.** Examples of valid values are:
  - `"index.html`" – served with File URL, like in PhoneGap
  - `http://localhost/index.html – served from the device's web server
  - `http://www.google.com` – any external URL

{% highlight javascript %}
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

###Tab bar colors

Tab bar color settings are application-wide and cannot be changed during runtime. Color settings are iOS-only. Colors are defined as 6-character RGB hex strings with a leading #.

{% highlight coffeescript %} 
steroids.config.tabBar.tintColor = "#00aeef"            # sets the tint of the whole tab bar
steroids.config.tabBar.tabTitleColor = "#ffffff"        # sets the title text color of a tab
steroids.config.tabBar.tabTitleShadowColor = "#000000"  # sets the title text shadow color of a tab
steroids.config.tabBar.selectedTabTintColor = "#11aeef" # sets the tint of a selected tab
{% endhighlight %}

##steroids.config.statusBar

Configures the status bar at the top of the screen. **iOS-only.**

```
steroids.config.statusBar.enabled = true
```

Sets the visibility of the [iOS status bar][apple-status-bar] at the top of the screen, showing the device's carrier, clock and battery status. Disabling the status bar increases the vertical space available for your application by 20 pixels.

##steroids.config.navigationBar

Configures your app's native nagivation bar. The navigation bar is enabled for each WebView independently by calling `steroids.navigationBar.show()`.

###Navigation bar colors

Navigation bar color settings are application-wide and cannot be changed during runtime. Colors are defined as 6-character RGB hex strings with a leading #. Color settings are **iOS-only.**

{% highlight coffeescript %}
# Set the tint, title text color and title text shadow color of the navigation bar
steroids.config.navigationBar.tintColor = "#00aeef"
steroids.config.navigationBar.titleColor = "#ffffff"
steroids.config.navigationBar.titleShadowColor = "#000000"
# Set the tint, title text color and title text shadow color of navigation bar buttons
steroids.config.navigationBar.buttonTintColor = "#363636"
steroids.config.navigationBar.buttonTitleColor = "#ffffff"
steroids.config.navigationBar.buttonShadowColor = "#000000"
{% endhighlight %}

## steroids.config.theme

Set an overall theme for the application, affecting the navigation bar and tab bar colors. Setting individual color values for the tab bar and navigation bar overrides this setting. **iOS-only.**

{% highlight coffeescript %}
steroids.config.theme = "default"  # iOS default style
steroids.config.theme = "black"    # the other iOS default style
{% endhighlight %}

## steroids.config.editor

Sets the editor command that is used in the Steroids console (i.e. `steroids connect`) with commands `edit` and `e`. By default, the editor is set to Sublime Text and the current project base directory is given as an argument. Arguments are always given as an array.

```
steroids.config.editor = "subl"
steroids.config.args = ["."]
```

##steroids.config.hooks

Sets up custom commands to run when making a Steroids build. The first hook is run before `steroids make`, the process where `app/` and `www/` folders are processed into the `dist/` folder.

```
steroids.config.hooks.preMake.cmd = "echo"
steroids.config.hooks.preMake.args = ["running yeoman"]
```

The other hook is run right after make, before running `steroids package`, the process that packages the app before sending it to client devices.

```
steroids.config.hooks.postMake.cmd = "echo"
steroids.config.hooks.postMake.args = ["cleaning up files"]
```

Notice that arguments are always given as an array.

[cloud-deploy]: /steroids/guides/steroids_npm/cloud-deploy/
[coffeescript]: http://coffeescript.org
[config-xml-ios]: /steroids/guides/ios/config-xml-ios/
[apple-status-bar]: https://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/MobileHIG/UIElementGuidelines/UIElementGuidelines.html#//apple_ref/doc/uid/TP40006556-CH13-SW29
