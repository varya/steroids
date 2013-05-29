---
layout: post
title:  "Deploying your app to the cloud"
date:   2013-05-27 13:51:34
categories: 
---

Steroids allows you to create an ad-hoc deployment of your app via the command

{% highlight bash %}
$ steroids deploy
{% endhighlight %}

When you do this, Steroids internally runs the `steroids make` and `steroids package` commands, which updates the contents of the `dist/` folder and creates a .zip package of your app. 

Steroids then checks if there is a valid `config/cloud.json` file (JSON with the fields `id` and `hash`). If not, a new `config/cloud.json` file is created with a fresh app ID and hash. If the file exists, Steroids uploads a new version of the app into the cloud, replacing the one previously deployed under that app ID.

Your app is then uploaded to the cloud. A share.appgyver.com site opens, with a QR code for sharing your app and an iOS web simulator for previewing it. Anyone can then access your app with the AppGyver Scanner app, provided they have the correct share.appgyver.com URL (or the QR code).

## App ID and AppGyver account

Each app ID is linked to one AppGyver account. Trying to use `$ steroids deploy` when your account doesn't have access to the app ID defined in `config/cloud.json` results in the deploy failing (even if you have the correct hash). 

Thus, if you are working on a shared project, each member needs to have their own `cloud.json` file. (One way to handle this is to create your own `.cloud.json.my_name` file, add it to `.gitignore` and symlink it to `config/cloud.json`.) We are working on a proper team support!