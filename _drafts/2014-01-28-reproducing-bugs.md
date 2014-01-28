---
layout: post
title:  "Creating excellent reproductions for issues"
date:   2014-01-28 13:51:34
categories: debugging
platforms: iOS, Android
---

You might run into an issue that seems like a bug with the AppGyver platform. It's frustrating when it happens, but we're dedicated to squashing every last thing that stands in the way of you creating awesome apps.

To help us track down the root cause of your issue, we ask you to create a reproduction scenario following these steps.

## Using the issue reproduction template project

We have a stripped-down [Steroids project](https://github.com/AppGyver/steroids-repro-template/) available on GitHub that we keep updated to use the latest Steroids.js version.

Now, for a good bug reproduction, it's very important that a bare minimum of HTML/CSS/JavaScript is used. This prevents false diagnoses – when the app is complex, it might look like something is broken on the native side, when in reality it's just a JavaScript error caused by a misconfigured framework, a CSS style acting up etc. You should strive to have just the issue and nothing else in your project. To demonstrate this, we created [a very simple project](https://github.com/AppGyver/steroids-repro-template/tree/topic/replaces-breaks-layers-push) to determine if using `steroids.layers.replace` messes up `steroids.layers.push` (an actual open issue).

To creata an excellent reproduction for an issue, clone [Steroids Repro Template](https://github.com/AppGyver/steroids-repro-template) to your computer and use it as a template when creating a repro case for the issue at hands. Remember to keep it simple! Then put your repro project on Github and let us know about it, so we find a way to fix it. The best way to do that is to create a new issue on [the Github issue tracker](https://github.com/AppGyver/scanner/issues) and link your repro case to the issue or to link it to an existing issue.

Thank you for contributing!

