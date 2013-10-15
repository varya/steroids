---
layout: post
title:  "Local development with Tizen"
date:   2013-05-20 13:51:34
categories: tizen
platforms: Tizen
---

### Related Guides
[Tizen Web App preferences in config.tizen.xml][config-xml-tizen-guide]

To develop your app on Tizen locally with Steroids, you need to instal AppGyver Scanner for Tizen, or use our Build Service to build a custom scanner.

## Installing AppGyver Scanner for Tizen

To get the Scanner app on your Tizen device, we need the `webtizen` command line tool, which is included with the Tizen SDK. Follow the offical [Tizen SDK install instructions](https://developer.tizen.org/downloads/sdk/installing-tizen-sdk).

The tool is located at `~/tizen-sdk/tools/ide/bin/webtizen` (or wherever you installed the SDK). Add the `bin` folder to your path in e.g. `~/.bashrc`:

{% highlight bash %}
export PATH=${PATH}:$HOME/tizen-sdk/tools/ide/bin
{% endhighlight %}

You'll need to open a new Terminal window for the changes to take palce.Next, download [AppGyver Scanner for Tizen](http://scanner_url_here). Connect your Tizen device to your computer via USB, make sure you've got USB debugging enabled (Settings > Developer Options) and then install the `scanner.wgt` file from the command line:

{% highlight bash %}
$ webtizen install -w scanner.wgt
{% endhighlight %}

### Building a custom scanner build
Alternatively you can request a custom Tizen Scanner build from the AppGyver Cloud.

First, ensure that your Steroids project has a properly configured [`www/config.tizen.xml`][config-xml-tizen-guide] file. Then, deploy your app to the AppGyver Cloud with `$ steroids deploy`.

Next up, go to your app in the [Build Service](http://cloud.appgyver.com/applications) and click the **Build a Scanner** button. A custom Tizen Scanner will be built, using the configuration options in your project's `www/config.tizen.xml`. Donwload the `.wgt` file and see the above instructions on installing it on your Tizen device.

## Connect to Steroids

Then, in your project folder, run `$ steroids connect --serve`. Open your Tizen Scanner app on the device (make sure they are in the same WLAN). In the IP field, enter the IP address for your computer running `$ steroids connect`. In the `location` field, enter the location for your initial view (i.e. the value of `steroids.config.location`). Note that localhost URLs do not work in Tizen. Then, click **Connect**.

Your app will load, and any changes made and pushed by pressing enter in the Steroids `connect` console will update on the device. To change the IP address, you need to restart the Scanner app. The refresh is also dependent on `steroids.js` being loaded to memory, so ensure that it is referenced in all views of your app!

## Known Steroids.js limitations

Steroids.js has currently very limited support on Tizen. `steroids.layers.push`, `steroids.layers.pop`, `steroids.modal.show` and `steroids.modal.hide` work and the app refreshes, but no other API calls are implemented.

## Load Cordova

The `cordova.tizen.js` file is included to the root of the `dist/` folder automatically by Steroids npm when using `$ steroids connect --serve`. The regular way of loading Cordova via localhost is not supported, so change your Cordova script tag to

{% highlight html %}
<script src="cordova.tizen.js"></script>
{% endhighlight %}
