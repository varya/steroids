Modern mobile devices have screens of varying pixel density, meaning that more or less pixels are crammed into the same physical dimensions. However, instead of simply reporting a larger resolution, the devices act as though they had less pixels to work with, but then use the extra pixels to render content in higher definition.

For example, setting an element's CSS to

{% highlight css %}
.sidebar {
  width:320px;
}
{% endhighlight %}

on a iPhone 4 or newer makes the element take up the entire screen, even though there's 640 physical pixels available on the screen.


This is a very messy situation for folks doing mobile CSS, and we'll do our best to explain 

On iOS, the term *Retina display* is used.















[pixel-is-not-a-pixel-blog]: http://www.quirksmode.org/blog/archives/2010/04/a_pixel_is_not.html
