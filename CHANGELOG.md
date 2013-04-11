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
