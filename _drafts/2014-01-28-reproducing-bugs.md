---
layout: post
title:  "Creating excellent reproductions for issues"
date:   2013-05-21 13:51:34
categories: debugging
platforms: iOS, Android
---

You might run into an issue that seems like a bug with the AppGyver platform. It's frustrating when it happens, but we're dedicated to squashing every last thing that stands in the way of you creating awesome apps.

To help us track down the root cause of your issue, we ask you to create a reproduction scenario following these steps.

## Using the issue reproduction template project

We have a stripped-down [Steroids project]() available on GitHub that we keep updated to use the latest Steroids.js version. Clone it to your computer.

Now, for a good bug reproduction, it's very important that a bare minimum of HTML/CSS/JavaScript is used. This prevents false diagnoses – when the app is complex, it might look like something is broken on the native side, when in reality it's just a JavaScript error caused by a misconfigured framework, a CSS style acting up etc. You should strive to have just the issue and nothing else in your project.

To demonstrate this, we are going to create a very simple project to determine if using `steroids.layers.replace` messes up `steroids.layers.push` (an actual issue that was fixed in Scanner for iOS v3.1.1).

