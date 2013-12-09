---
layout: post
title:  "Safari Web Inspector: iOS"
date:   2013-05-24 13:51:34
categories: debugging
platforms: iOS
---

<div class="alert" markdown="1">
**Note:** The Safari Web Inspector is available for iOS only, and requires OS X. We are working on building a similar solution for Android and other operating systems.
</div>

Safari offers a very powerful Web Inspector tool for debugging your app. Unfortunately, Apple doesn't allow the Web Inspector to be used on apps downloaded from the App Store, so the debugging tools can currently be used only with the iOS Simulator. You can still use [Weinre][guide-debugging-weinre] to debug apps running on your phone.

Even so, the Safari Web Inspector is the only fully functional Web Inspector tool currently available for debugging Steroids apps (apart from running your app in a web browser), so we recommend using it whenever possible.

## Using the Safari Web Inspector

*iOS7 requires your Safari to be updated to version 6.1 or later.* You'll need to restart your computer after updating Safari for the Web Inspector to work.

To get started, open your Steroids app in the iOS Simulator by typing `simulator` in the Steroids console (or `$ steroids simulator` in another Terminal window). Please note that `$ steroids connect` needs to be running when calling `simulator` or `$ steroids simulator`. Otherwise the autoconnect fails with a connection error.

Next, enable Safari's developer tools. Open Safari's preferences by selecting *Safari* > *Preferences* from the top menu, go to the Advanced tab and check the Show Developer menu checkbox.

Now, you should see a *Develop* menu item in Safari's top menu bar. Open the *Develop* > *iPhone Simulator* menu, and you should see a list of WebViews currently open in your app. (`contextmenu.html`, `loading.html` and `background.html` are used internally by Steroids.)

You can also skip the Safari menu altogether. When in `steroids connect` prompt, you can use `d` or `debug` command to get a list of currently open WebViews in the iOS Simulator. The command takes an argument like `d banana/index.html` to open the Safari Web Inspector for given WebView. Partial file/path names work also.

###Inspecting a WebView

Select a WebView. You now have direct Web Inspector access to it. You can edit the DOM and use the JavaScript console. The console also displays errors and `console.log` output.

If you type in `window.location.reload();`, the WebView reloads itself, which allows you to see network requests and possible console errors that happen when the WebView loads.

You can even debug JavaScript by inserting breakpoints: open a .js file in the Safari Web Inspector (e.g. from the *Resource* tab) and click on the line numbers to insert break points. Then, reload the WebView. JavaScript execution will pause at the breakpoints, and the Debug tab shows the current call stack.

[guide-debugging-weinre]: /steroids/guides/debugging/weinre
