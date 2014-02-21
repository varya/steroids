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

Safari offers a very powerful Web Inspector tool for debugging your app. Apple doesn't allow the Web Inspector to be used on apps downloaded from the App Store (i.e. the regular AppGyver Scanner), so the debugging tools can currently be used only with the iOS Simulator or with a [custom Debug Builds](/steroids/guides/cloud_services/debug-build/).

The Safari Web Inspector is the only fully functional Web Inspector tool currently available for debugging Steroids apps (apart from running your app in a web browser), so we recommend using it whenever possible.

## Using the Safari Web Inspector

*Note that your Safari must be version 6.1 or later. You'll need to restart your computer after updating Safari for the Web Inspector to work.*

To get started, open your Steroids app in the iOS Simulator by typing `simulator` in the Steroids console (or `$ steroids simulator` in another Terminal window). Please note that `$ steroids connect` needs to be running when calling `simulator` or `$ steroids simulator`. Otherwise the autoconnect fails with a connection error.

Alternatively, you can use a [Debug Scanner or Debug Ad Hoc build](/steroids/guides/cloud_services/debug-build/) for debugging your app. **When using a physical device, you need to connect your device to your computer with a wire.**

Next, enable Safari's developer tools. Open Safari's preferences by selecting *Safari* > *Preferences* from the top menu, go to the Advanced tab and check the Show Developer menu checkbox.

Now, you should see a *Develop* menu item in Safari's top menu bar. Open the *Develop* > *iPhone Simulator* menu, and you should see a list of WebViews currently open in your app. (`contextmenu.html`, `loading.html` and `background.html` are used internally by Steroids.)

You can also skip the Safari menu altogether. When in the `steroids connect` prompt, you can use `d` or `debug` command to get a list of currently open WebViews in the iOS Simulator. The command takes an argument like `d views/banana/index.html` to open the Safari Web Inspector for given WebView. Partial file/path names work also, so if you have an open WebView at `views/car/index.html` path you can simply write e.g. `d car/ind`.

If you cannot see any WebViews in your Safari Develop menu, restarting your computer might help.

###Inspecting a WebView

Select a WebView. You now have direct Web Inspector access to it. You can edit the DOM and use the JavaScript console. The console also displays errors and `console.log` output.

If you type in `window.location.reload();`, the WebView reloads itself, which allows you to see network requests and possible console errors that happen when the WebView loads.

You can even debug JavaScript by inserting breakpoints: open a .js file in the Safari Web Inspector (e.g. from the *Resource* tab) and click on the line numbers to insert break points. Then, reload the WebView. JavaScript execution will pause at the breakpoints, and the Debug tab shows the current call stack.
