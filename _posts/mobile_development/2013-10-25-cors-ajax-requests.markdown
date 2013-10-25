---
layout: post
title:  "Configuring server side for CORS AJAX requests"
date:   2013-06-12 13:51:34
categories: mobile_development
platforms: Android, iOS
---

Modern browsers are configured to automatically dismiss HTTP requests made from one domain to another due to [same origin policy](http://en.wikipedia.org/wiki/Same_origin_policy). Since a Steroids WebView is effectively a full-screen WebKit-based browser, this means that you need to do some configuration to get your remote API requests working correctly. The easiest way to do this is to use [Cross-Origin Resource Sharing](http://www.w3.org/TR/cors/).

The basic trick is to add an `Access-Control-Allow-Origin: *` header to all HTTP responses from your server, enabling  The [enable-cors.org](http://enable-cors.org/) website has information on how to do this for various server environments. In addition, HTML5 Rocks has an excellent [CORS tutorial](http://www.html5rocks.com/en/tutorials/cors/) that works directly in Steroids – although you don't need the initial helper method code that handles platform differences, since the WebViews on all Steroids platforms support the [XMLHttpRequest2](http://www.html5rocks.com/en/tutorials/file/xhr2/) object, which has CORS support. Thus, you can just use `xhr = new XMLHttpRequest()`.
