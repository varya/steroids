---
layout: post
title:  "Using the .android extension"
date:   2013-05-21 13:51:34
categories: 
---

**Supported Platforms: Android**

There are some situations where it becomes very complicated to use the same file for both the iOS and Android version of your app. For example, some HTML5 features are available on iOS and not on Android. The `datetime` input type works fine on iOS:

{% highlight html %}
<input type="datetime">
{% endhighlight %}

But for Android, the `datetime` input type is not available, so maybe you'll want to use the basic `text` input type and use a JavaScript solution for picking the time. Or, perhaps there's a feature in your app that is only available on iOS, and you need to hide the button that opens it on Android. Or your CSS styles are slightly different on the two platforms, or you need a different background image for Android.

Instead of using JavaScript to detect the user agent and manipulate the code dynamically, Steroids allows you to simply create a copy of any project file and add the `.android` extension to it. On Android devices, any file with the `.android` extension will be used instead of the original file. On iOS, everything functions normally.

<div class="alert">
There is currently a known issue where .android files are cached permanently on the device (but replaced by newer .android files).
</div>
