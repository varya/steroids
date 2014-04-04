---
layout: post
title:  "WebView background color (iOS)"
date:   2013-05-27 13:51:34
categories: steroids-js
platforms: iOS
---

On iOS, each WebView (i.e. layer, modal or drawer) will have its own background color. This is the color shown when the HTML content is scrolled past its boundary:

<img src="/steroids/images/steroids-js/webview_background_color.png" width="50%">
*The darker grey background is the WebView's default background color.*

The API call [`steroids.view.setBackgroundColor("#FFFFFF")`](http://docs.appgyver.com/en/edge/steroids_Steroids%20Native%20UI_steroids.view_view.setBackgroundColor.md.html) is used to set the background color for a WebView to the given hex color. It must be called separately for each WebView.

## Status bar and background color

For a new WebView, the HTML content rendering starts below the status bar. This means that the WebView background color will be shown under the status bar when you first load the page:

<img src="/steroids/images/steroids-js/statusbar_background_color_1.png" width="50%">
*WebView background color is set to `#FF0000`*

Now, if we set the WebView background to match the page background, it looks seamless:

<img src="/steroids/images/steroids-js/statusbar_background_color_2.png" width="50%">
*WebView background color is set to `#DFE2E2`, matching the `body` `background-color`*

## Navigation bar and background color

If you enable the native navigation bar with `steroids.view.navigationBar.show()`, the navigation bar will stretch under the status bar also, and HTML content rendering is shifted to start under the navigation bar. The status bar will look alright, but scrolling the HTML content past its borders will still reveal the WebView background color. (Also, the navigation bar is slightly transluscent, so the WebView background color will affect its tint in a barely-noticable way.)

## Drawer and background color

Like other WebViews, the drawer WebView's HTML content will start rendering below the status bar, causing the WebView background color to show through. This can look strange, especially if the native navigation bar is used in the main view – the status bar seems to suddenly change color between the drawer view and the main view. You have a few options:

* If your drawer view doesn't have to scroll, you can fake a status bar background color with the `steroids.view.setBackgroundColor()` API call. You can also implement a scrolling container inside the othewise-unscrollable HTML `body`, which will leave the status bar illusion in place.
* Use a [custom navigation bar background image](http://guides.appgyver.com/steroids/guides/project_configuration/config-application-coffee/#navigation_bar_background_images_ios_only), where the status bar background color matches the WebView background color of the drawer.
* Set the WebView background color to match the HTML's background color (so that at least the drawer WebView and status bar look like they belong together).

## Best practices

For the cleanest native-like look, you should use a single background color for your WebView (at least on the top and bottom edge of the HTML content) and use `steroids.view.setBackgroundColor()` to match the background color. This way, it looks like you have transparent HTML content scrolling on top of a static background, like in native apps.

You can use the `<preference name="ViewIgnoresStatusBar" value="false" />` in `www/config.ios.xml` to make the WebView start under the status bar, so that the WebView background color becomes visible only when scrolling.