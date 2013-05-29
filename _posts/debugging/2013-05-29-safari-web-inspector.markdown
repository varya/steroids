---
layout: post
title:  "Debugging with the Safari Web Inspector"
date:   2013-05-21 13:51:34
categories: debugging
platforms: ios
---

Debugging with the Safari Web Inspector

Note: Safari's Web Inspector is available for iOS only. We are working on building a similar solution for Android.
Safari offers a very powerful Web Inspector tool for debugging your app. Unfortunately, Apple doesn't allow the Web Inspector to be used on apps downloaded from the App Store, so the debugging tools can currently be used only with the iOS Simulator. You can still use Weinre (see below) to debug apps running on your phone.

To get started, open your Steroids app in the iOS Simulator by running $ steroids simulator while $ steroids connect is running.

Next, enable Safari's developer tools. Open Safari's preferences by selecting Safari > Preferences from the top menu, go to the Advanced tab and check the Show Developer menu checkbox.

Now, you should see a Develop menu item in Safari's top menu. Open the Develop > iPhone Simulator menu, and you should see a list of WebViews currently open in your app. (contextmenu.html, loading.html and background.html are used internally by Steroids.)

Select a WebView. You now have direct Web Inspector access to it. You can edit the DOM and use the JavaScript console (console.log output is captured there). If you type in window.location.reload();, the WebView reloads itself, which allows you to see network requests and possible console errors that happen when the WebView loads.

You can even debug JavaScript by inserting breakpoints: open a .js file in the Web Inspector (e.g. from the Resource tab) and click on the line numbers to insert break points, then reload the WebView. JavaScript execution will pause at the breakpoints, and the Debug tab shows the current call stack.