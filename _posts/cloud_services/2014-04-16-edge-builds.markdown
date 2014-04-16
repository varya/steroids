---
layout: post
title:  "Edge builds"
date:   2014-04-16 13:51:34
categories: cloud_services
platforms: iOS
---

It takes a while for us to go through the full QA testing, documentation and App Store submission/approval process for a new Scanner version. Thus, there are often useful features and bugfixes that are already in our codebase, but not yet packaged into a release.

To get access to the latest features as soon as they are usable, you can request an Edge build from the Build Service. Edge builds are created with the latest stable version of our codebase (note that stable doesn't necessary mean bug-free – see fine print below).

### Building an Edge build

Edge builds are created with the same build config settings as your regular builds. Simply set up your app for iOS in the [Build Service](http://cloud.appgyver.com/applications) and click on the **Build Edge** button to request an Edge build.

### Using the next branch of Steroids.js

The Edge features are usable with the [next branch of Steroids.js](https://github.com/AppGyver/steroids-js/tree/next). To use them, clone the Steroids.js repo to a local folder and checkout the `next` branch. Then, run `$ npm install` to install the required dependencies, and then run `$ grunt` to create the `dist/steroids.js` file. Copy the file to your project manually and include it with an appropriate `<script>` tag.

### Fine print

The Edge version hasn’t gone through full QA testing and thus might have some new and surprising bugs that will get squashed before the actual release, so it’s not advised to submit Edge builds to the App Store (and if you're forced to do so, make sure to test your app thoroughly).
