---
layout: post
title:  "Debugging Best Practices"
date:   2013-05-21 13:51:34
categories: debugging
platforms: iOS, Android
---

Below is a collection of tips and best practices that we've found useful while debugging apps built with AppGyver. Please make sure you've read the following articles first, as they contain info about the basic tools you should use when debugging a Steroids app.

* (iOS) [Debugging with the Safari Web Inspector][safari-wi]
* (Android) [Debugging with Android Dev Tools][adt]
* (both platforms) [Debugging with Weinre][weinre]

## Use console.log

`console.log` provides a good, non-blocking way of outputting information from your app. Use it to e.g. ensure that a function call is reached, to see what values certain variables take, output Cordova API error messages etc. Some external JavaScript libraries and the JavaScript VM also output errors to the console log, so keeping it open is a good idea in any case.

The output of `console.log` commands from your Steroids app is available in several ways:

* On iOS: by running `$ steroids simulator` (the output is visible in the Terminal window running the command, text only)
* On iOS: by using the [Safari Web Inspector][safari-wi] (fully functional console log)
* On Android: by using the [Android Developer Tools][adt] and the LogCat program (text only)
* On both platforms: by using [Weinre][weinre] (only after Weinre has loaded via JavaScript, otherwise fully functional console log)

## Use alerts

`alert()` calls show up on the actual device, so they are useful to e.g. ensure that a function call has been reached. Note that alerts are blocking on mobile devices, meaning that JavaScript execution stops until the alert dialogue has been dismissed. This can be troublesome, so `console.log` is preferred in most cases.

## Use JSON.stringify on objects

By calling `JSON.stringify(myAwesomeObject)`, the object and its properties are transformed into a human-readable text string. Thus, `console.log( JSON.stringify(myAwesomeObject) )` is a good way to see what's going on with an object, if you lack access to a proper console log.

## Debug and develop in the browser

Type

<pre class="terminal">
$ steroids serve
</pre>

while `steroids connect` is running. This starts a local web server that will serve the contents of your `dist` folder at `http://localhost:4000/`. By using the server instead of just opening the .html files in a browser, you can e.g. use absolute paths for any resource URLs, like on the actual device.

Of course, `steroids.js` and Cordova APIs will be unavailable, so your JavaScripts probably won't work as intended. They will also perform faster than on the actual mobile device. Still, iterating CSS styles and your HTML structure is often significantly faster with a web browser – just make sure to check from time to time that the page is rendered correctly on the actual devices also.

### What browser to use?

Steroids uses the WebKit engine on both iOS and Android, so you should use Chrome or Safari for debugging.

### Touch event emulation

On Chrome, open the Developer Tools and click the cog button in the bottom right corner. Check *Overrides* > *Emulate touch events*. Your mouse clicks will now trigger the correct `touchstart`, `touchend` and `touchmove` events.

### Using the correct viewport size

You can simply resize your browser window to the correct pixel width (the *Overrides* tab in Chrome allows you to do this nicely).

In addition, [Screenqueri.es] is a cool website that allows you to see how a HTML page looks when rendered in different screen sizes. It supports localhost URLs, so it works nicely with `steroids serve`.

## Ensure that your HTML5 features are supported

Android is still lagging a bit behind iOS on the implementation of certain HTML5 features, and some of the cutting-edge stuff is not available at all on mobile devices.

The website [caniuse.com][caniuse] has good, up-to-date tables on what features are supported by which platforms. Be sure to check it out before you scratch your head wondering why e.g. `<input type="datetime">` just doesn't seem to work on Android.


[Screenqueri.es]: http://screenqueri.es/
[caniuse]: http://caniuse.com
[safari-wi]: /guides/debugging/safari-web-inspector/
[adt]: /guides/debugging/adt/
[weinre]: /guides/debugging/weinre/