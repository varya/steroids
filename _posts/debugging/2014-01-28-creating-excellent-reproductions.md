---
layout: post
title:  "Creating excellent reproductions for issues"
date:   2014-01-28 13:51:34
categories: debugging
platforms: iOS, Android
---

You might run into an issue that seems like a bug with the AppGyver platform. It's frustrating when it happens, but we're dedicated to squashing every last thing that stands in the way of you creating awesome apps.

To help us track down the root cause of your issue, we ask you to create a reproduction scenario with our template project.

## Creating a reproduction

Now, for a good bug reproduction, it's very important that a bare minimum of HTML/CSS/JavaScript is used. This prevents false diagnoses – when the app is complex, it might look like something is broken on the native side, when in reality it's just a JavaScript error caused by a misconfigured framework, a CSS style acting up etc. You should strive to have just the issue and nothing else in your project. To demonstrate this, we created [a very simple project](https://github.com/AppGyver/steroids-repro-template/tree/topic/replaces-breaks-layers-push) to determine if using `steroids.layers.replace` messes up `steroids.layers.push` ([an actual issue](https://github.com/AppGyver/scanner/issues/101) that has since been fixed).

The way to let us know something is broken is create a new issue on [the Scanner Github issue tracker](https://github.com/AppGyver/scanner/issues) and link your repro case to the issue (or link your repro to an existing issue, if it is related).

To create an excellent reproduction for an issue, you have two options.

### Using Steroids Sandbox

For simple issues, the easiest method is to use the [Steroids Sandbox](http://sandbox.appgyver.com) to create your repro case. We'll be immediately able to reproduce the issue on our end and start working on a fix.

### Using the Steroids Repro Template

Alternatively, you can clone the [Steroids Repro Template](https://github.com/AppGyver/steroids-repro-template) to your computer and use it as a template when creating a repro case for the issue at hands. Remember to keep it simple! Then put your repro project on GitHub and let us know about it, and we'll find a way to fix the issue.

Thank you for contributing!
