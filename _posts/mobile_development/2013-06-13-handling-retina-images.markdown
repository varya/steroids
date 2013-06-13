---
layout: post
title:  "Handling images on Retina/high DPI screens"
date:   2013-06-12 13:51:34
categories: mobile_development
platforms: Android, iOS
---

Many modern mobile devices have a **device-pixel ratio** that's higher than one. This means that for every CSS pixel, there is more than one physical pixel on the screen, allowing for higher definition in rendering content. For example, a Retina iPhone has a device-pixel ratio of 2. Though the screen has 640 physical pixels horizontally, the device acts as though it only has 320 pixels.

Devices report their device-pixel ratio via the <code>window.devicePixelRatio</code> property.

To display high-resolution images correctly on a device with a Retina or otherwise high DPI display, you need to use CSS to scale the elements to 50% of their size. The WebKit engine will take care of the rest.

Let's target devices with a device-pixel ratio of 2 (the most common case for modern devices). To scale an `<img>` element, you can simply add set the width to 50%:

{% highlight css %}
img#hd-image {
  width:50%;
}
{% endhighlight %}

To scale a background image, make sure your background image is twice the size of the element, and then set the background to take up the entire element:

{% highlight css %}
.info-box {
  width:200px; /* Half the width of myHDBackground.png */
  background-image: url("images/myHDBackground.png");
  background-size: 100%
}
{% endhighlight %}

Since `background-size` is calculated relative to the element's dimensions, setting it to 50% would make your background image repeat.

You can use the `-webkit-min-device-pixel-ratio` and `-webkit-max-device-pixel-ratio` media queries to create separate CSS for devices with different device-pixel ratios:

{% highlight css %}
@media (-webkit-max-device-pixel-ratio: 1){
  .info-box {
    background-image: url("images/myRegularBackground.png");
  }
}
{% endhighlight %}

## iOS "@2x" Convention

iOS has a convention of putting `@2x` before the file extension of Retina images, e.g. `icon@2x.png`. Though Steroids has no current support for handling the "@2x" string in WebViews, some native UI icons set via [config/application.coffee][config-application-coffee-guide] require the "@2x" string to be present. It's a handy way of separating your normal and Retina-optimized images.

[config-application-coffee-guide]: /steroids/guides/project_configuration/config-application-coffee/
