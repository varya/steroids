---
layout: post
title:  "Installing Tizen apps"
date:   2013-05-20 13:51:34
categories: tizen
platforms: Tizen
---

### Related Guides
- [Building your app for Tizen][tizen-build-config]
- [Local development with Tizen][tizen-local-development-guide]

To get a downloaded Tizen `.wgt` on your Tizen device, we need the `webtizen` command line tool, which is included with the Tizen SDK. Follow the offical [Tizen SDK install instructions](https://developer.tizen.org/downloads/sdk/installing-tizen-sdk), if you haven't already.

The tool is located at `~/tizen-sdk/tools/ide/bin/webtizen` (or wherever you installed the SDK). Add the `bin` folder to your path in e.g. `~/.bashrc`:

{% highlight bash %}
export PATH=${PATH}:$HOME/tizen-sdk/tools/ide/bin
{% endhighlight %}

You'll need to open a new Terminal window for the changes to take place. Connect your Tizen device to your computer via USB, make sure you've got USB debugging enabled (Settings > Developer Options) and then install the `application.wgt` file from the command line:

{% highlight bash %}
$ webtizen install -w application.wgt
{% endhighlight %}

Your app will install on the device.
