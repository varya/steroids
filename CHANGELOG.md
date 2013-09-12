## 2.7.22 (TODO)

Bugfixes:
  - Removed line trying to load `controllers/application.js` from generator templates where the file wasn't used.

## 2.7.21 (2013-09-09)

Fixed issue where certain Android devices couldn't open projects when using the Steroids npm on Windows, support for symbolic links in project, minor debug fixes.

Bugfixes:
  - In `$ steroids package` on Windows, use 7zip command-line executable instead of node-archiver to create the project zip. This fixes an issue where certain Android devices couldn't open the created project archive.
  - `$ steroids deploy --debug` outputs the share.appgyver.com URL to Terminal before trying to open it in the browser.
  - `$ steroids make` now copies symbolic links to `dist/`.

## 2.7.20 (2013-09-06)

Clarified instructions on updating the Steroids npm to work on a newer Node.js version.

Bugfixes:
  - Preinstall and preupdate Node.js version check now has a note about having to use `$ npm install steroids -g` instead of `$ npm update steroids -g`, if previous install was on Node 0.8.x.

## 2.7.19 (2013-09-06)

WINDOWS SUPPORT ADDED!

Also: Node.js version requirement is now v0.10.x (with v0.11.x supported), minor fixes based on forum feedback.

Breaking:
  - Doesn't work any more with Node v0.8.x.

Changes:
  - Updated Steroids npm to use Node.js version 0.10.x (with v0.11.x also supported).
  - Windows support added.

Bugfixes:
  - When the local QR code is shown, the web page URL is shown in the `--debug` output (i.e. `$ steroids connect --debug`).

Known Issues:
  - The `e`/`edit` shortcut for opening a text editor from the Steroids console crashes if the editor command is not found.
  - The `e`/`edit` shortcut in Steroids console is not available on Windows.

## 2.7.18 (2013-09-03)

Fixes issues reported in the forums, <3 [forums.appgyver.com](http://forums.appgyver.com).

Bugfixes:
  - Login callback, local QR code and Weinre web pages and `$ steroids connect --serve` now open using `127.0.0.1` instead of `localhost` to fix issues with non-standard hosts files.
  - New project plugins folder README file includes link to https://github.com/AppGyver/steroids-plugins.
  - `http://localhost/` URLs no longer get the `:13101` port appended to them automatically.

## 2.7.17 (2013-08-21)

Changes:
  - Updated Steroids.js to version 2.7.7

## 2.7.16 (2013-08-20)

Support for merges dir.

Changes:
  - New projects have Cordova like `merges` and `plugins` directories.
  - Added `merges` directory support to steroids make process.
  - New projects have `.gitignore` for `.DS_Store` and `/dist`.

Bugfixes:
  - Fallback for login url open (print to console)

## 2.7.15 (2013-08-19)

Changes:
  - Updated Steroids.js to version 2.7.6

Bugfixes:
  - More informative QR code screen
  - `ng-sql-scaffold` now includes `sqliteplugin.android.js` for Android Cordova SQLite plugin compatibility

## 2.7.14 (2013-08-14)

Fixed a crashing error on Linux.

Bugfixes:
  - fixed a crashing error caused by a typo'd require statement having the wrong case for the filename (the bug only affected Linux users due to Linux observing a stricter case sensitivity for the file system compared to OS X)

## 2.7.13 (2013-08-09)

Unified steroids commands, nicer usages and other improvments.

Changes:
  - `steroids connect --watch --watchExclude` option added to exclude paths and files, see also application.coffee option for more permanent excludes
  - `steroids debug` renamed to `steroids weinre`
  - `steroids safaridebug` renamed to `steroids safari`
  - `steroids safari` now lists open WebViews
  - `steroids safari <path>` opens the target document directly in Safari Dev Tools, also accepts partial paths
  - `d` and `debug` commands in the `steroids connect` prompt work as a shortcut for `steroids safari`
  - `steroids serve` is deprecated, use `steroids connect --serve`
  - `steroids usage` is now colorized and has better wording
  - iOS simulator can't be stopped anymore (it will always stop before starting again, this fixes bugs with resolution changes)

## 2.7.12 (2013-08-08)

Bugfixes and experimental feature of reloading with steroids connect --serve

Changes:
  - `steroids connect --serve` now reloads documents when `steroids push` is made

Bugfixes:
  - `ng-touchdb-resource` did not match semantic version of steroids-js
  - `steroids serve` did not work without tabs

## 2.7.11 (2013-08-08)

Changes:
  - New generator: `steroids generate ng-sql-scaffold` for an AngularJS CRUD scaffold with Persistence.js and WebSQL/SQLite-plugin as a backend
  - `steroids connect --serve` also serves application for browser debuggin
  - preMake hook will end the process when error code is not 0
  - `steroids serve` opens URL configured in `steroids.config.location` or the first tab if tabs are enabled.
  - `ng-resource` generator refactored to use a single JSON file for local resource data
  - `steroids serve` rewrites apps with tabs to support debugging with browser (experimental)
  - default `www/config.platform.xml` exposes built-in plugins
  - steroids.js 2.7.4 is default for new apps.

## 2.7.10 (2013-08-02)

New generators, build hooks invoked on file system changes, command to open Safari Develop menu directly, steroids.js version updated.

Changes:
  - `steroids safaridebug` opens the Safari Develop menu using AppleScript, allowing for quick access to Safari Web Inspector
  - new generator: `steroids generate ng-touchdb-resource` for an Angular.js resource that syncs data in an external CouchDB database with a local TouchDB database.
  - new generator: `steroids generate bb-scaffold` for a CRUD scaffold using Backbone.js, includes example configuration for Stackmob (or any REST-API)
  - steroids.js 2.7.3 is default for new apps.

Bugfixes:
  - `steroids.config.hooks.preMake` and `postMake` are now invoked with `--watch` option

## 2.7.9 (2013-07-29)

Simulator supports different SDKs, bugfixes

Changes:
  - `steroids simulator --deviceType` supports SDK version setting, `--deviceType=iphone@5.1`
  - includes 2.7.6 version of the iOS Scanner Simulator

Bugfixes:
  - `steroids.config.hooks.preMake`  and `postMake` are actually executed when update is triggered from connect prompt
  - Fixed "Using native drawer shows black drawer" problem with newer Simulator (2.7.6)
  - `steroids generate ng-resource` doesn't generate order by code anymore

## 2.7.8 (2013-07-26)

Lovin' Angular.js! Proper "Multi-Page Application" generators: ng-resource and ng-scaffold!

Changes:
  - `steroids generate ng-scaffold todo` generates a CRUD scaffold, includes example configuration for Stackmob (or any REST-API)
  - `steroids generate ng-resource animal` generates a local resource with local data in `www/data`

## 2.7.7 (2013-07-25)

iOS simulator launching is improved, console.log override to work around Cordovas bug.

Changes:
  - Added support for default iOS simulator device type launching with `steroids connect --deviceType=<type>`
  - `www/javascripts/console.log.js` added to catch `console.log` messages before Cordova is ready.
  - removed `steroids chat` command, please visit our forums at http://forums.appgyver.com

Breaking changes:
  - `steroids simulator --type` is now longer supported, changed to `steroids simulator --deviceType=<type>`

## 2.7.6 (2013-07-16)

Fixes iOS simulator height.

Bugfixes:
  - iOS simulator now extends to full height when started with `--type=iphone_retina_4_inch`
  - calling steroids commands with `--debug` did not output anything

## 2.7.5 (2013-06-17)

Resources generated with `steroids generate` use Topcoat, fixes to generated examples, Ratchet CSS library removed

Changes:
  - Removed obsolete rename-config-xml grunt task
  - Generator `resource and `ng-resource` now use Topcoat
  - Removed Ratchet CSS library from default project

Bugfixes:
  - Fixed default project template loading screen spinner size
  - Generated camera example uses Topcoat loading spinner, rotates images correctly, iPad camera roll popover positioned correctly
  - Generated photo gallery example rotates images correctly
  - Minor fixes to other generated examples

## 2.7.4 (2013-06-14)

Android bugfixes, tutorials updated for better clarity, Topcoat CSS library used in default project, tutorials and examples

Bugfixes:
  - onerror.js.android changed to onerror.android.js in default project template
  - Several examples fixed for Android

Changes:
  - Default project, loading.html, all tutorials and all examples now use Topcoat for CSS styles
  - Updated all tutorials for better clarity

## 2.7.3 (2013-06-11)

New Cordova examples, Android loading screen, index.html info text clarified

Bugfixes:
  - Default `index.html` had wrong instructions about scanning another app or restarting the current one on Android

Changes:
  - Default `www/loading.png` file added to new project template, used by the Android loading screen. See the [loading.png guide](http://guides.appgyver.com/steroids/guides/android/loading-png/) for more information.
  - Cleaned up `www/config.android.xml` from unused elements. See the [Android config.xml guide](http://guides.appgyver.com/steroids/guides/project_configuration/config-xml-android/)) for more information.
  - New Cordova examples: `storage` and `notification`
  - Generators that added a jQuery dependency now use jQuery 2.0.x
  - Generators that added an Angular.js dependency now use Angular.js 1.0.7
  - Friendlier error message for 'steroids' tutorial config/application.coffee overwrite
  - Cleaned up `config/application.coffee`

## 2.7.2 (2013-06-10)

Installation and tutorial improvements

Bugfixes:
  - `controllers` tutorial gives a proper error if the user tries to generate it before generating the `steroids` tutorial
  - Check for correct node version before installing to avoid issues

## 2.7.1 (2013-06-04)

Updated iOS Simulator and Steroids.js with support for new API's

Changes:
  - Application skeletons are generated with steroids-js 2.7.1
  - iOS Simulator updated to 2.7.1
  - `steroids chat` opens support chat
  - New tutorial `steroids`
  - `controllers` tutorial updated to reflect changes to other tutorials

Bugfixes:
  - Checks new versions using semantic versioning

## 2.7.0 (2013-06-03)

Public beta release

Changes:
  - default project now includes instructions on how to access AppGyver Scanner context menu
  - 'begin' tutorial remade

## 0.10.17 (2013-06-03)

Improved simulator

Changes:
  - `steroids simulator` now accepts --type to specify the device's type.

Bugfixes:
  - Simulator launch failure detection improved

## 0.10.16 (2013-05-31)

Update checking improved

Changes:
  - `steroids update` also checks for updates

Bugfixes:
  - Wrong message was displayed when new NPM was available

## 0.10.15 (2013-05-31)

config.ios.xml and config.android.xml

Changes:
  - Require login for local development due update checking for different user groups
  - Cordova.plist deprecated and replaced with config.ios.xml (Android config.xml support is upcoming)
  - added loading screen tint color to config/application.coffee

## 0.10.14 (2013-05-30)

Client update checking, Linux compatibility

Changes:
  - Automatically checks for new versions of AppGyver Scanner

Bugfixes:
  - Compatibility with sh shell in preinstall script
  - Prevent simulator launching in other OS than Mac OS X

## 0.10.13 (2013-05-29)

Custom editor, hooks and more consistency with Cordova

Changes:
  - a new app is served via the File protocol by default (instead of localhost)
  - editor launching is defined in `application.coffee`
  - steroids.config.hooks.preMake and steroids.config.hooks.postMake for running own scripts
  - steroids update checking passes the action performed
  - steroids update checking passes the user_id of currently logged in user

## 0.10.12 (2013-05-24)

Weinre updated, bugfixes

Changes:
  - `steroids update` informs if Steroids NPM is in the latest version
  - login and logout give nicer output
  - updated weinre (more supported browsers)
  - disabled unicode pill in prompt :(

Bugfixes:
  - enabling, disabling and enabling tabs again fixed
  - application.coffee is now properly reloaded on every client refresh
  - `steroids debug` works correctly with custom ports
  - Cordova camera example now shows a loading spinner while the captured photo is loading
  - better error handling in Cordova compass example
  - if project directory contains word "app" its not replaced as "dist"

## 0.10.11 (2013-05-23)

Custom port caused problems when not used (defaults did not work), fixed ng-resource

Bugfixes:
  - Custom --port settings bettered, ports back to defaults
  - angular type checking was not included in the last bug fix

## 0.10.10 (2013-05-22)

Bug fixes, better notifications

Changes:
  - Also running update, login and deploy check for new version

Bugfixes:
  - Fixed EventEmitter memory leaking
  - example generator output gave an incorrect location for the created layout file.

## 0.10.9 (2013-05-21)

Fixed resource generation

Changes:
  - Steroids update checking no longer hammers npm repository

Bugfixes:
  - resource and ng-resource generators did not tell the location of index view.
  - ng-resource angular defined checking was not done correctly

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
