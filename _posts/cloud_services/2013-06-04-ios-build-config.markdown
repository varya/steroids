---
layout: post
title:  "iOS  Build Configuration"
date:   2013-05-24 13:51:34
categories: cloud_services
platforms: iOS
---

### Related Guides
* [Configuring custom plugins for your app][custom-plugin-config]
* [Building a Debug build](/steroids/guides/cloud_services/debug-build/)

The AppGyver Build Service lets you create an IPA package of your application that you can distribute either ad hoc or submit to the Apple App Store.

All iOS application builds need to be signed with an app provisioning profile and a developer certificate. To get these, you need to sign up to the Apple Developer Program, as well as have a Mac for genereating the necessary files.

To build iOS apps with the AppGyver Build Service, you need to create a `.p12` certificate file and a `.mobileprovision` provisioning profile file. The following sections will tell you how to do this.

## Generating a .p12 certificate file

Sign in with your Apple ID to [developer.apple.com][apple-dev]. Then, open the [Certificate listing][apple-certificate-list] under the iOS Dev Center.

Click on the plus button in the upper right corner. Under the **Production** category, select the **App Store and Ad Hoc** option. Click **Continue** and follow the instructions on the screen about creating a Certificate Signing Request via Keychain Access, and uploading it to Apple.

After you're done, it takes a couple of moments for Apple to generate the iOS Distribution Certificate for you. You can then find it under the Production category:

<img src="/steroids/images/ios_build/download_certificate.png">

Download the `.cer` file to your computer, and then double-click on it to add it to your Keychain.

Next, open Keychain Access and find your **iPhone Distribution certificate**. Expand it: it should have the private key that you generated with your Certificate Signing Request.

<strong>Note: Make sure that you use a <em>Distribution</em> certificate, not a <em>Development</em> certificate!</strong>

<img src="/steroids/images/ios_build/export_certificate.png">

Right-click on it and select the Export option. Make sure the file format is set to "Personal Information Exchange (.p12)", and save the file on your disk.

You will be asked to set up a password for the file. The password will be later used by the AppGyver Build Service to access your `.p12` file.

## Generating provisioning profiles

Provisioning profiles are used by Apple to control how an IPA package can be used. There are two kinds of IPA packages that you can build for your iOS app, and two kinds of provisioning profiles needed:

* **Ad Hoc**, which you can send to testers or run on your own devices. You need to set up which devices are allowed to install the pacakge.
* **App Store**, which you can upload to App Store for distribution. An App Store build cannot be run on local devices – only uploaded to the App Store.

### Generating an App ID

To create a provisioning profile, you need a unique App ID for your app.

Go to [developer.apple.com][apple-dev] and open the [App IDs listing][apple-app-id-list] under the iOS Dev Center.

Click the plus button in the top-right corner to create a new App ID. Give your App ID a Description (only used in the iOS Dev Center). Skip the App Services section (support for Push Notifications is coming soon). Make sure the Explicit App ID option is selected, and give your app a Bundle ID.

The Bundle ID is a reverse-domain style unique string for your app, e.g. `com.mycompany.myawesomeapp`. The Bundle ID must match the one you enter to the AppGyver Build Service.

If you don't want your App Store build to overwrite your Ad Hoc build, you should give them separate App and Bundle IDs.

If you're planning on building a custom Scanner to e.g. use [custom plugins][custom-plugin-config], you should create a separate App ID and Bundle ID for your Scanner app, e.g. `com.mycompany.myawesomeapp.scanner`.

Click Continue and then Confirm to create your App ID.

### Registering devices

*Note that during development, you don't need to register any devices if you use the [cloud-deploy][cloud-deploy] functionality of Steroids – anyone with AppGyver Scanner and the correct URL can download and try out your app.*

You need to specify beforehand which devices are allowed to install your Ad Hoc build. Go to [developer.apple.com][apple-dev] and open the [Devices listing][apple-devices-list].

Click the plus button in the top-right corner to register a new device. Enter a name for the device (used in the iOS Dev Center only) and give its UDID.

An UDID is a unique, 30-character string that identifies your iOS device. To see your device's UDID:

1. Connect your device to your computer with a USB cable
2. Open the device in iTunes
3. Click on the device's Serial Number field
4. The Serial Number will change to your device's UDID

Click Continue and Confirm to register your device.

Registering new devices can be tedious. We highly recommend using [Testflight][testflight] for handling the distribution of your Ad Hoc builds.

### Generating an Ad Hoc provisioning profile.

Sign in with your Apple ID to [developer.apple.com][apple-dev] and open the [Provisioning Profiles listing][apple-provisioning-list] under the iOS Dev Center.

Click the plus button in the top-right corner to create a new provisioning profile. Then

1. Select the Ad Hoc option.
2. Select your App ID.
3. Select your developer certificate.
4. Select which devices are allowed to install the pacakge.
5. Give your provisioning profile a name and click Generate.

After you're done, download the `.mobileprovision` file to your computer.

If you are planning on creating a custom Scanner build, you should create a separate `.mobileprovision` file for it by following the above steps (or you'll end up overwriting your Ad Hoc build).

### Generating an App Store provisioning profile

Sign in with your Apple ID to [developer.apple.com][apple-dev] and open the [Provisioning Profiles listing][apple-provisioning-list] under the iOS Dev Center.

Click the plus button in the top-right corner to create a new provisioning profile. Then

1. Select the App Store option.
2. Select your App ID.
3. Select your developer certificate.
3. Give your provisioning profile a name and click Generate.

After you're done, download the `.mobileprovision` file to your computer.

## Using the AppGyver Build Service

Now that you have the `.mobileprovision` and `.p12` files, we can build your IPA.

First, you need to create a cloud-deployed build of your app. You can do this with `$ steroids deploy` in your project folder. See the [cloud deployment guide][cloud-deploy] for more information.

After you have deployed your app to the cloud, you need to set up a bunch of options so that we can build your app properly. Go to [cloud.appgyver.com][appgyver-cloud], click on your app and then on the Configure Build Settings button.

On the top row, you have to:

* Set a Display Name for your applicaiton. This is the name that will be shown below the app icon on devices.
* Set a Bundle Identifier. Use reverse-domain style, e.g. `com.domain.myappname`. *The Bundle Identifier must match the one set up for the App ID that your `.mobileprovision` file uses.*
* Set Version. This is the internal version number of your app. It won't be shown publicly, but can be used to differentiate between internal releases.
* Set Short Version. This is the public version number that will show up in App Store and in your app's Settings.
* Upload a `.mobileprovision` file. There's a different section for Ad Hoc and App Store builds, so make sure to choose the correct file.
* Upload your `.p12` certificate file.
* Enter your `.p12` certificate file password (the one you set up when you exported it from Keychain Access).
* Configure your [custom plugins][custom-plugin-config].

The Scanner Build is a special build of your application intended for development with the Steroids CLI. It allows you to create a Scanner app that includes the custom plugins defined in the plugins field. As such, a Scanner Build doesn't show your actual application, but rather lets you scan a QR code to connect to a computer running the Steroids server. It's a good idea to create a separate `.mobileprovision` file and App/Bundle ID for your Scanner Build.

For information about Debug builds, see the [Building a Debug Build guide](/steroids/guides/cloud_services/debug-build/).

Note that there's a known issue where Steroids CLI checks for the version number of custom-built Scanner apps also. To ensure that Steroids CLI lets you connect, make sure your Scanner app's semantic Version number is higher than 2.7.0.

Then, you have to:

* Select which orientations the app is allowed to rotate to on iPhone and iPad.
* Select the target devices (iPhone/iPad)
* Enter any custom URL schemes for your app, see [custom URL schemes guide][custom-url-scheme-guide].
* Enter your Facebook App ID (if using the Facebook Connect plugin)
* Entery your Urban Airship App Key / Secret (if using the Urban Airship plugin)


* Upload the different size icons for your app. **NOTE: You need to upload custom app icons for all icon sizes to be able to build for App Store. This is to ensure that apps in App Store do not have the default Steroids icon anywhere.**
* Upload the different size splashscreens for your app.

After you're done, click Update Settings. Then, you can use the Build an Ad Hoc build and Build for App Store buttons on the Build for Distribution tab to request a new build of your app.

Building the app takes a few moments, after which you'll get an e-mail with a link to the downloadable IPA. You can also see your build history and download earlier builds by clicking on the Show Build History button.

[appgyver-cloud]: http://cloud.appgyver.com
[apple-certificate-list]: https://developer.apple.com/account/ios/certificate/certificateList.action?type=distribution
[apple-app-id-list]: https://developer.apple.com/account/ios/identifiers/bundle/bundleList.action
[apple-dev]: http://developer.apple.com
[apple-devices-list]: https://developer.apple.com/account/ios/device/deviceList.action
[apple-provisioning-list]: https://developer.apple.com/account/ios/profile/profileList.action
[cloud-deploy]: /steroids/guides/steroids_npm/cloud-deploy/
[custom-plugin-config]: /steroids/guides/cloud_services/plugin-config/
[custom-url-scheme-guide]: /steroids/guides/steroids-js/custom-url-schemes
[testflight]: http://www.testflightapp.com
