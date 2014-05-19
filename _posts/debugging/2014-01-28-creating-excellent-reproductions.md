---
layout: post
title:  "Creating excellent reproductions for issues"
date:   2014-01-28 13:51:34
categories: debugging
platforms: iOS, Android
---

You might run into an issue that seems like a bug with the AppGyver platform. It's frustrating when it happens, but we're dedicated to squashing every last thing that stands in the way of you creating awesome apps.

(Before going forward, be sure to check through [the Steroids GitHub issue tracker](https://github.com/AppGyver/steroids/issues) to see if someone else has ran into the same problem and perhaps created a repro for it already.)

To help us track down the root cause of your issue, we ask you to create a reproduction scenario for the bug. You have two options:

### Using Steroids Sandbox

For simple issues, the easiest method is to use the [Steroids Sandbox](http://sandbox.appgyver.com) to create your repro case. We'll be immediately able to reproduce the issue on our end and start working on a fix.

### Using the Steroids Repro Template

Alternatively, you can clone the [Steroids Repro Template](https://github.com/AppGyver/steroids-repro-template) to your computer and use it as a template when creating a repro case for the issue at hands. Remember to keep it simple!

## Creating an excellent reproduction

Now, for an excellent bug reproduction, it's very important that a bare minimum of HTML/CSS/JavaScript is used. This prevents false diagnoses – when the app is complex, it might look like something is broken on the native side, when in reality it's just a JavaScript error caused by a misconfigured framework, a CSS style acting up etc. You should strive to have just the issue and nothing else in your project. To demonstrate this, we created [a very simple project](https://github.com/AppGyver/steroids-repro-template/tree/topic/replaces-breaks-layers-push) to determine if using `steroids.layers.replace` messes up `steroids.layers.push` ([an actual issue](https://github.com/AppGyver/scanner/issues/101) that has since been fixed).

## I've got a reproduction, now what?

Once you have your repro case and instructions, please create a new issue on [the Steroids GitHub issue tracker](https://github.com/AppGyver/steroids/issues) and link your repro case to the issue.

Thank you for contributing!
