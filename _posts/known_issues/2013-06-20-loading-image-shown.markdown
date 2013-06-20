---
layout: known_issue
title:  "Loading image shown under a HTML page without custom CSS (Android)"
date:   2013-05-27 13:51:34
categories: known_issues
platforms: Android
---

On Android, the default CSS styles used by WebViews set the `body` and `html` background color to transparent. This has the effect that when a HTML document does not set an opaque background for either `body` or `html`, the Android [loading.png][loading-png-guide] is shown underneath. Thus, for pages with little or no other content, it can seem like the app is stuck on the loading view.

The issue is fixed by simply setting an opaque background color (or image) to either element:

{% highlight css %}
body {
  background: #fff;
}
{% endhighlight %}

[loading-png-guide]: /steroids/guides/android/loading-png/