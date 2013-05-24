---
layout: post
title:  "Debugging Best Practices"
date:   2013-05-21 13:51:34
categories: debugging 
---

#STILL WIP

Below is a collection of tips and best practices that we've found useful while debugging apps built with AppGyver.

## Use console.log

The staple of 

## Use alerts

`alert()` calls show up on the actual device, so they are useful to e.g. ensure that a function call has been reached. Note that alerts are blocking on mobile devices, meaning that JavaScript execution stops until the alert dialogue has been dismissed. This can be troublesome, so `console.log` is preferred in most cases.

## Use JSON.stringify on objects

By calling `JSON.stringify(myAwesomeObject)`, the object and its properties are transformed into a human-readable text string. Thus, `console.log( JSON.stringify(myAwesomeObject) )` is a good way to see what's going on with an object, if you lack access to a proper console log.

## Develop in the browser

Type 

{% highlight bash %}
$ steroids serve
{% endhighlight %}

while `steroids connect` is running to start a local web server that will serve the contents of your `dist` folder. This allows you to e.g. use absolute paths for resource URLs. Of course, `steroids.js` and Cordova will be unavailable, so your JavaScripts probably won't work as intended, but e.g. iterating CSS styles or your HTML structure can be faster with a web browser.