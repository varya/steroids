---
layout: post
title:  "Local development with Tizen"
date:   2013-05-20 13:51:34
categories: tizen
platforms: Tizen
---

### Related Guides
- [Tizen Web App preferences in config.tizen.xml][config-xml-tizen-guide]
- [Installing Tizen apps][installing-tizen-apps-guide]

To develop your app on Tizen locally with Steroids, you need to use our Build Service to build a scanner.

## Installing the Scanner app

[Click here](http://appgyver.assets.s3.amazonaws.com/tizen-scanner.wgt) to download the Tizen Scanner app `.wgt` file, then follow the instructions in the [Installing Tizen apps guide][installing-tizen-apps-guide].

## Connect to Steroids

You should have the Scanner app available on your Tizen device now.

Then, in your project folder, run `$ steroids connect --serve`. Open your Tizen Scanner app on the device (make sure they are in the same WLAN). In the IP field, enter the IP address for your computer running `$ steroids connect`. In the `location` field, enter the location for your initial view (i.e. the value of `steroids.config.location`). Then, click **Connect**.

Your app will load, and any changes made and pushed by pressing enter in the Steroids `connect` console will update on the device. To change the IP address, you need to restart the Scanner app. The refresh is also dependent on `steroids.js` being loaded to memory, so ensure that it is referenced in all views of your app!

## Known Steroids.js limitations

Steroids.js has currently very limited support on Tizen. `steroids.layers.push`, `steroids.layers.pop`, `steroids.modal.show` and `steroids.modal.hide` work and the app refreshes, but no other API calls are implemented.

## Load Cordova

The `cordova.tizen.js` file is included to the root of the `dist/` folder automatically by Steroids CLI when using `$ steroids connect --serve`. The regular way of loading Cordova via localhost is not supported, so change your Cordova script tag to

{% highlight html %}
<script src="cordova.tizen.js"></script>
{% endhighlight %}

## Use the Tizen web emulator

You can also open the bundled Tizen web emulator by running

{% highlight bash %}
$ steroids simulator --deviceType=tizenweb
{% endhighlight %}

[config-xml-tizen-guide]: /steroids/guides/tizen/config-xml-tizen/
[installing-tizen-apps-guide]: /steroids/guides/tizen/installing-apps/
