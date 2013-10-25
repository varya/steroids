---
layout: post
title:  "Steroids Hacks"
date:   2013-10-24 11:31
categories: steroids-js
platforms: iOS
---

This document collects hacks made by us and our users to extend Steroids functionalities and overcome certain (current) limitations.

These are certainly not best practices, but useful tips and tricks as we continue to develop the platform.

### Faking a modal with layers.push and animations

To fake a modal with navigation bar, you can use the following code:

{% highlight coffeescript %}
# in index.html
fakeModal = new steroids.views.WebView "fakeModal.html"
modalAnimation = new steroids.Animation "slideFromBottom"

steroids.layers.push
  view: fakeModal
  animation: modalAnimation
{% endhighlight %}

So, now our new layer animates into view by sliding up from the bottom of the screen, just like a modal.

{% highlight coffeescript %}
# in fakeModal.html

# create an empty navigation bar button without callbacks
emptyButton = new steroids.buttons.NavigationBarButton()
emptyButton.title = ""

# replace back button with an empty button
steroids.view.navigationBar.setButtons
  left: [emptyButton]
  overrideBackButton: true

# show navigation bar
steroids.view.navigationBar.show("Fake Modal")
{% endhighlight %}

Calling `steroids.layers.pop()` programmatically closes the "modal". If you wanted, you could change the empty left button's title to e.g. `"Done"` and add a `steroids.layers.pop()` as its `onTap` callback. Note that since this our "modal" is actually a regular layer, it doesn't e.g. cover tab bar tabs.