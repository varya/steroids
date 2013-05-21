## 0.10.9 (TODO)

TODO

Changes:
  - Steroids update checking no longer hammers npm repository

## 0.10.8 (2013-05-20)

New examples

Changes:
  - `steroids connect --port 1234` is supported, requires iOS client 2.7.0 to work.
  - Allow `steroids generate` to be run without being in a Steroids project folder (displays usage)
  - New examples added (accessible via `steroids generate example exampleName`):
    - Cordova: accelerometer, audio, camera, compass, device, geolocation
    - Steroids: drumMachine, photoGallery

Bugfixes:
  - `steroids connect` checks if port is taken.
  - `steroids deploy` gives more help and explains how deploy works when deployed.

## 0.10.7 (2013-05-16)

Tutorial flow fixed, updated generators

Changes:
  - Default generators no longer generate application.html or application.js files

Bugfixes:
  - Tutorial had typos and flow was broken.
  - Controllers tutorial did not check for file overwrites

## 0.10.6 (2013-05-16)

Friendlier error messages, error handling and bugfixes

Changes:
  - All steroids http callbacks are now prefixed with `/__appgyver`
  - `steroids connect` screen now links to AppGyver Scanner for Android also.
  - More verbose output on CoffeeScript and Sass compiliation (to see error messages in context)
  - Shows logo in `steroids create newProject`

Bugfixes:
  - When using `steroids serve` it no longer serves usage document for `/index.html`
  - Friendlier error messages for `steroids create` and `steroids generate`
  - Friendlier error messages for `steroids generate tutorial` and `steroids generate example`
  - Checks if `steroids <cmd>` needs to be run in steroids project directory
  - Any IP address that is not for localhost is okay
  - `steroids create projectName` refuses to overwrite existing folder
  - Default index.html had old tutorial generator command

## 0.10.5 (2013-05-14)

Bigger QR code for improved scanning.

Changes:
  - QR Code in `steroids connect` is bigger by default (improves scanning with iOS)

Bugfixes:
  - Steroids no longer assumes that command is always named `steroids`
  - Built-in grunt always used globally installed steroids

Experimental:
  - `steroids chat <nickName>` opens a support chat session

## 0.10.4 (2013-05-08)

New example generation syntax, new examples

Changes:
  - Example generator now uses following syntax:
    `steroids generate example modal`
  - New examples: layerStack, navigationBar

Bugfixes:
  - modal generator had some copy-pasta, fixed.

## 0.10.3 (2013-05-07)

Modal and animation example generators

Changes:
  - `steroids generate modal modalExample` creates an example of using modal windows.
  - `steroids generate animation animationExample` creates an example of using animations.

## 0.10.2 (2013-05-07)

Preload example generator

Changes:
  - `steroids generate preload preloadExample` creates an example of preloading webviews.

Bugfixes:
  - Default `application.css` fixed to work with input elements while disabling other callouts.


## 0.10.1 (2013-05-07)

Drawer example generator

Changes:
  - `steroids generate drawer drawerExample` creates an example of the new native Facebook-like drawer.
  - Default `application.css` disables WebKit callouts on long press in new projects.
  - `steroids make` no longer complains about controllers named `xxxController`


## 0.10.0 (2013-05-06)

Versioned to 0.10.0 with 0.7.0 Steroids.js because of Scanner dependency on iOS (2.3.5)

## 0.9.10 (2013-05-02)

Updated Steroids.js references to 0.6.2

## 0.9.9 (2013-04-26)

Android compatibility

Changes:
  - www/javascripts/onerror.js.android overrides default onerror.js to prevent errors before
    the Android runtime doesn't throw an error on non-existing JavaScript files

## 0.9.8 (2013-04-25)

Default project structure is improved.

Changes:
  - Improved Angular.js generator (ng-resource)
  - loading.html looks better
  - Tutorial project is more informative: $ steroids generate tutorial begin
  - Everything works also with Android
  - Matches latest steroids.js conventions

## 0.9.7 (2013-04-15)

Linux compatibility.

Bugfixes:
  - Fixes `error: Error: Cannot find module './steroids/deploy'` on Linux, we used case insensitive filesystems.

## 0.9.6 (2013-04-12)

Notifies on updates.

Changes:
  - When running `steroids connect`, steroids will connect to npm repository to check for a newer version.
    If a newer version is found, a banner is printed with upgrade notice.

## 0.9.5 (2013-04-11)

Usability improvments.

Changes:
  - Opening http://youripaddress:4567 gives more friendlier page.
  - Simulator detects if it failed to launch and instructs on how to reset it.

## 0.9.4 (2013-04-10)

Start recommending NVM, the Node Version Manager

Changes:
  - Installation does not force user to chown `/usr/local`, readme recommends to use NVM.

## 0.9.3 (2013-04-09)

Deploy did not make a new deployment package.

Bugfixes:
  - `steroids deploy` did not make a new package in `/tmp/steroids_project.zip` that resulted in
    failure if no previous package was found or deploy was done with an older build.

## 0.9.2 (2013-04-09)

Linux compatibility

Bugfixes:
  - Only interfaces starting with "en" were embedded in QR code. Now everything but localhost is added.

## 0.9.1 (2013-04-08)

0.9.0 contained 0.6.0 steroids-js that was immediately updated to 0.6.1.

Bugfixes:
  - Sample projects use 0.6.1 that works (0.6.0 was broken)

## 0.9.0 (2013-04-08)

Released iOS Scanner 2.3.4 to App Store, updated minor to reflect that.

## 0.8.2 (2013-04-05)

Support for iOS Scanner 2.3.4

Changes:
  - new projects have a bower dependency to steroids-js package, instead of a github url
  - new projects are created with steroids-js 0.6.x dependencies

## 0.8.1 (2013-03-25)

Linux compatibility fix

Features
  - none

Bugfixes:
  - Fixes `error: Error: Cannot find module './config'` on Linux, we used case insensitive filesystems.
    Thanks to Itzcoatl Calva.

## 0.8.0 (2013-03-22)

Support for iOS Scanner 2.3.3

Features
  - Support for iOS Scanner 2.3.3, refuses to work with 2.2.2 (steroids.js 0.5.0 requires 2.3.3)

Bugfixes:
  -


## 0.7.2 (2013-03-20)

Changelog started (again)

Features:
  - QR code can be shown from connect prompt
  - Initial support for launching editors from connect prompt, currently hardcoded "mate"
  - p for push in connect prompt

Bugfixes:
  -
