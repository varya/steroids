---
layout: post
title:  "Connecting when your device doesn't have a camera"
date:   2013-05-27 13:51:34
categories: steroids_npm
platforms: iOS, Android
---

There are some devices (the original iPad, some Kindle versions etc.) that can run Steroids-made apps but do not have a built-in camera and thus can't scan QR codes. With the following (admittedly rather hackish) workaround you can still connect your device with the Steroids CLI for development and testing:

1. Have the AppGyver Scanner app installed on the device
2. Run `$ steroids connect`
3. In the web browser that opens and shows the QR code, copy the value of the `qrCodeData` query parameter – looks something like<br> `appgyver%3A%2F%2F%3Fips%3D%255B%2522192.168.1.156%2522%255D%26port%3D4567`
4. Run it through an [URL decoder][url-decoder] to get a link that uses the `appgyver` protocol:<br>`appgyver://?ips=%5B%22192.168.1.156%22%5D&port=4567`
5. Mail that link to an account that's accessible on the device (or put it on a web page)
6. Open the mail or web page and click on the link on your mobile device

AppGyver Scanner will recoginze the custom URL protocol, open, and automatically connect to the IP address specified in the URL.

Also, if you open the share.appgyver.com URL of a [cloud-deployed][cloud-deploy-guide] app on your mobile device, there's a link that opens the app in AppGyver Scanner automatically.

[url-decoder]: http://meyerweb.com/eric/tools/dencoder/
[cloud-deploy-guide]: /steroids/guides/steroids_npm/cloud-deploy/
