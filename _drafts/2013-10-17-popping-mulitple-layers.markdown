---
layout: post
title:  "Popping multiple layers"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS, Android
---

There are two ways to remove views from the layer stack hierarchy: calling `steroids.layers.pop()`, which removes the currently visible WebView from the layer stack by animating it away, or `steroids.layers.popAll()`, which takes you to the root WebView of your app. (Tapping the native back button calls `steroids.layers.pop()` internally, and double-tapping a tab bar icon on iOS calls `steroids.layers.popAll()` internally.)

However, there might be cases where you need to pop multiple WebViews at once. As an example, you have an index view, which links to a show view, which links to an edit view. Let's say the items come from a local SQLite database. Thus, your layer stack looks something like:

{% highlight javascript %}
{index.html}
{show.html?id=14}
{edit.html?id=14} // visible for user
{% endhighlight %}


Now, say you remove the item in the edit view. The app should return to the index view, but calling `steroids.layers.pop()` from the edit view just takes you back to the show view, which now points to an item no longer in the database.

Before better `steroids.pop.*` API calls are implemented, there's a workaround that uses the `visbilitychange` event listener.

## Using visibilitychange to pop multiple layers in succession

What we do is add a `visibilitychange` event listener to the show view (you'd anyway want to use one to make sure the data is always up-to-date):

{% highlight coffeescript %}
# show.html
document.addEventListener "visibilitychange", ->
  if document.visibilityState is visible
    if destroyed
      steroids.layers.pop()
    else
      # update data from database
{% endhighlight %}

The code is run every time the view becomes visible (i.e. is rendered on screen). Then, if the internal variable `destroyed` is true (which means the corresponding item no longer exists), we pop the layer.

Next we need to set the `destroyed` variable somehow. We do this via `window.postMessage`:

{% highlight coffeescript %}
# show.html
document.addEventListener "message", (msg)->
  if msg.data is "destroyed" and msg.id is @id
{% endhighlight %}




