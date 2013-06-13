---
layout: post
title:  "Moving from File protocol to localhost"
date:   2013-06-12 13:51:34
categories: phonegap
platforms: Android, iOS
---

###Related guides
* [Steroids preferences with config/application.coffee][config-application-coffee-guide]
###Related APIs
* [steroids.app.absolutePath][app-absolutepath-api]
* [steroids.app.absoluteUserFilesPath][app-absoluteuserfilespath-api]
* [steroids.app.path][app-path-api]
* [steroids.app.userFilesPath][app-userfilespath-api]


PhoneGap serves your files via the **File protocol**. This means that all HTML documents and other assets in your app are accessed via either absolute paths that start with `file://` or via relative paths, e.g. `<img src="../../images/dolan.png">`.

##Why is the File protocol incovenient
Relative paths can only be used when the location of the current document is known, e.g. in CSS files or with HTML elements' `src` attributes. If your document structure changes, you have to update all affected relative paths.

In addition, many Cordova API calls require an absolute URL. Since the folder structure from the root of the device's file system to your app is rather complex, specifying the absolute URL can be tedious (the [steroids.app.absolutePath][app-absolutepath-api] property is a convenient helper).

As an alternative, Steroids allows you to serve your project files from a local web server that runs inside the Steroids runtime. This has multiple benefits, including being able to use absolute URLs with a root that points to your app directory, as well as using the [.android. extension][android-extension-guide] to serve Android-specific version of certain files.

##Serve HTML pages from localhost

The first step is simple: change the `steroids.config.location` property in `config/application.coffee` to load from localhost:

{% highlight coffeescript %}
steroids.config.location = "http://localhost/index.html"
{% endhighlight %}

Any `window.location` changes, `href` attributes and so on in your project should be similarly changed to load from localhost.

##Switch your assets to absolute URL paths

In HTML documents loaded from localhost, starting a URL string with `/` is equivalent to starting it with `http://localhost/`. The web server at localhost serves files from your application directory (equivalent to the contents of the `dist/` folder that the Steroids NPM creates). Thus, instead of writing

{% highlight css %}
body {
  background-image: url("../../images/background.png");
}
{% endhighlight %}

you can write

{% highlight css %}
body {
  background-iamge: url("/images/background.png");
}
{% endhighlight %}

(Assuming that your file is at `www/images/background.png`.)

The same absolute paths can be used with HTML elements' `src` attributes.

##Ensure that cross-domain requests work

When serving a HTML document via the File protocol, [same origin policy][same-origin-policy-wikipedia] is disabled, since the WebKit engine trusts HTML documents coming from the local file system. Thus, AJAX requests to external domains succeed without using [CORS][cors-wikipedia].

However, when serving your project from localhost, WebKit's same origin policy kicks in. You need to configure the CORS HTTP headers in your external locations to correctly respond to your app's requests.

Alternatively, by using the `steroids.config.hosts` property in `config/application.coffee`, Steroids can fool external locations into thinking that a request orignated from a different host. This means you don't have to necessarily configure e.g. your backend's CORS responses differently. You can read more in the [config/application.coffee guide][config-application-coffee-guide].

##Ensure that nothing is served from file://

If you happen to reference any assets via their absolute File URL path (e.g. starting with `file://`), they will fail to load. This is because the localhost web server is operating with the `http://` protocol, which makes WebKit consider everything from the `file://` protocol to be unsafe and deny the request (otherwise malicous sites could access your computer's files at will).

When a file is requested from the localhost web server, the Steroids runtime looks in the application folder (which, as we remember, has the same contents as `dist/`). What this means is that you can e.g. use Cordova's Media API in a much simpler fashion:

{% highlight javascript %}
var audio = new Media("http://localhost/sounds/macgyver_theme.mp3");
{% endhighlight %}

This would load a file that is in your project at `www/sounds/macgyver_theme.mp3`.

[android-extension-guide]: /steroids/guides/android/android-extension/
[config-application-coffee-guide]: /steroids/guides/project_configuration/config-application-coffee/
[app-path-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.path.md.html#steroids.app.path
[app-userfilespath-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.userFilesPath.md.html#steroids.app.userFilesPath
[app-absolutepath-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.absolutePath.md.html#steroids.app.absolutePath
[app-absoluteuserfilespath-api]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.absoluteUserFilesPath.md.html#steroids.app.absoluteUserFilesPath
[same-origin-policy-wikipedia]: http://en.wikipedia.org/wiki/Same_origin_policy
[cors-wikipedia]: http://en.wikipedia.org/wiki/Cross-origin_resource_sharing