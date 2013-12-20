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

There is currently no Scanner app available for Tizen. This means you need to develop your Tizen Steroids app with the Tizen web simulator, and then test it on your Tizen device by building it through the Build Service.

## Using the Tizen simulator

Open two Terminal windows to your project folder. In the first one, run `$ steroids connect --serve`. In the second one, run `$ steroids simulator --deviceType=tizenweb`.

The Tizen web simulator will open in a new Chrome browser. Make changes to your app, and press enter in the Steroids console to push the changes to the simulator – same as you would when developing with a Scanner app.

The refresh is dependent on `steroids.js` being loaded to memory, so ensure that it is loaded in all views of your app!

## Known Steroids.js limitations

Steroids.js has currently very limited support on Tizen. `steroids.layers.push`, `steroids.layers.pop`, `steroids.modal.show` and `steroids.modal.hide` work and the app refreshes, but no other API calls are implemented.

## Load Cordova

The `cordova.tizen.js` file is included to the root of the `dist/` folder automatically by Steroids CLI when using `$ steroids connect --serve`. The regular way of loading Cordova via localhost is not supported, so change your Cordova script tag to

{% highlight html %}
<script src="cordova.tizen.js"></script>
{% endhighlight %}

[config-xml-tizen-guide]: /steroids/guides/tizen/config-xml-tizen/
[installing-tizen-apps-guide]: /steroids/guides/tizen/installing-apps/
