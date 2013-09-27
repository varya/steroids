---
layout: post
title:  "App Structure on the Device"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS, Android
---

This guides explains how your app files are structured on the actual device. There are two types of folders that you should care about:

* the **App folder**, a read-only folder containing your static app data – namely, the contents of the `dist/` folder in your Steroids project
* the **User Files folder**, a read-and-write folder meant for user files created during app runtime – downloads, photos, audio recordings etc.

## App folder on iOS

When using the Scanner app, your project files (the contents of the `dist/` folder in your project) reside in a *read-only* folder whose path is randomized to prevent WebKit cache issues. The location, accessible via the [steroids.app.absolutePath][steroids.app.absolutePath] variable (or, relative to the `Documents/` folder, via [steroids.app.path][steroids.app.path]), looks something like

{% highlight javascript %}
/var/mobile/Applications/AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA/Scanner.app/
Documents/applications/local/123456789
{% endhighlight %}

where the `AAAAA...` string is an **App Unique Identifier** and the number string at the end is a randomized folder that changes every time you push changes to the device. Both the `steroids.app.absolutePath` and `steroids.app.path` take into account the changed folder, so use them when necessary.

### Example
All `steroids.app` variable require the Steroids `ready` event to have fired. So, to access an image at `www/images/my_image.png` with a File url, you would use:

{% highlight javascript %}
steroids.on("ready", function() {
  var url = "file://" + steroids.app.absolutePath + "/images/my_image.png"
});
{% endhighlight %}

### Stand-alone app builds
When you create a stand-alone (i.e. Ad Hoc or App Store) build of your app, the App folder path is just

{% highlight javascript %}
/var/mobile/Applications/AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA/MyAwesomeApp.app/
Documents/Application
{% endhighlight %}

and the `steroids.app.absolutePath` and `steroids.app.path` variables are updated accordingly.

## User Files folder on iOS

On iOS, the User Files folder is simply the root of `Documents/` (both in Scanner and stand-alone builds), so [steroids.app.absoluteUserFilesPath][steroids.app.absoluteUserFilesPath] returns

{% highlight javascript %}
/var/mobile/Applications/AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA/Scanner.app/Documents
{% endhighlight %}

The User Files folder is read-and-write and preserved over app updates, so files stored there will not disappear.

## App and User Files folders on Android

On Android, the App and User Files folders work the same, their location is just different. On Android, the App folder is, depending on the device, at something like

{% highlight javascript %}
/storage/emulated/0/Android/data/com.appgyver.android/files/Application
{% endhighlight %}

and the User Files folder at

{% highlight javascript %}
/storage/emulated/0/Android/data/com.appgyver.android/files
{% endhighlight %}

Preventing cache issues on Android doesn't require changing the App folder path, so it is kept the same on both Scanner and stand-alone builds.

## Accessing files in App and User Files folders

You can navigate the phone file system with standard path operators, e.g. to access something in the User Files folder from `www/index.html` on a Scanner app in iOS, you could use

{% highlight html %}
<img src="../../../my_image.png">
{% endhighlight %}

However, this would not work in a stand-alone build, since the relative folder structure is different, and it looks ugly to boot. **Don't do this!**

### Localhost to the rescue

When your WebView content is served via `localhost`, e.g.

{% highlight coffeescript %}
steroids.config.location = "http://localhost/index.html"
{% endhighlight %}

both the User Files folder and the App folder are used to search for assets. Thus, if you have an image in the root of your User Files folder, you can reference to it simply with

{% highlight html %}
<img src="/my_image.png">
{% endhighlight %}

instead of having to type out the whole `file://` URL.

If a file exists with the same name in both the User Files and App folders, the file in the User Files folder will be preferred over the file in the App folder.

## Kitchensink example

In the [Steroids Kitchensink][kitchensink], you can find an example (under `app/views/camera/` and `app/controllers/camera.coffee`) where we take a picture with the Cordova Camera API, move the photo from the temporary folder to the User Files folder and then disply it using an absolute path (i.e. just `"/my_image.png"`).

[custom-dependencies-tasks]:  /steroids/guides/project_configuration/custom-dependencies-tasks/
[kitchensink]: https://github.com/AppGyver/kitchensink
[steroids.app.absolutePath]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.absolutePath.md.html#steroids.app.absolutePath
[steroids.app.absoluteUserFilesPath]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.absoluteUserFilesPath.md.html#steroids.app.absoluteUserFilesPath
[steroids.app.path]: http://docs.appgyver.com/en/edge/steroids_Steroids%20App%20and%20Device_Steroids.app_app.path.md.html#steroids.app.path