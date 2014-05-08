---
layout: post
title:  "Installing the Steroids CLI package"
date:   2013-05-27 13:51:34
categories: steroids_npm
platforms: iOS, Android
---

##Installing the Required Dependencies

First, you need to make sure that you have these set up:

* [Git][git] (required by external Node.js libraries)
  * **On Windows**, be sure to select the *"Use Git from Windows Command Prompt"* option in the install wizard.
* [Python v2.7 or higher][python] (required by external Node.js libraries)
  * **On Windows**, be sure to select the *"Add python.exe to Path"* feature in the install wizard.
  * **On OS X**, Python should be preinstalled. You can check your version by running <br>`$ python` in the Terminal.
* **OS X only**: [Xcode][xcode] with Command Line Tools (for code compilation)

Most importantly, you need to have [Node.js][nodejs] version 0.10.x (or 0.11.x) and [npm package management][npm] installed.

### Installing Node.js on Windows

Install Node.js with the [official Windows installer](http://nodejs.org/download/). Make sure that all components are selected for installation. Note also that Node.js [doesn't support Cygwin](https://github.com/joyent/node/issues/5618) at the moment.

### Installing Node.js on OS X and Linux

The easiest and recommended way to install Node.js on OS X is with [Node Version Manager (NVM)][nvm]. Install NVM with:

<pre class="terminal">
$ curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh
</pre>

Note that by default NVM adds initialization lines to `.bash_profile`, so you need to make sure these lines are loaded (by restarting Terminal).

## Manual install on Linux

The `sh` command might not work with certain Linux distributions. You need to install NVM manually:

#### Install dependencies
<pre class="terminal">
$ sudo apt-get install build-essential libssl-dev curl git-core
</pre>

#### Download NVM
<pre class="terminal">
$ git clone git://github.com/creationix/nvm.git ~/.nvm
</pre>

#### Source NVM from your bash shell

Add the following line to the end of your `~/.bashrc` file:

```
source ~/.nvm/nvm.sh
```
#### Open a new bash session
Type `$ bash` in the Terminal to open a new Bash session. The `$ nvm` command should now work.

### Installing the correct version of Node.js

To install Node.js 0.10.x with NVM and set it as the default Node.js version to use:

<pre class="terminal">
$ nvm install 0.10
$ nvm use 0.10
$ nvm alias default 0.10
</pre>

Alternatively, if you don't want to use NVM, you can install Node.js and npm package management from [nodejs.org][nodejs]. This has several downsides, including having to use `sudo` with global npm installs and updates. Steroids officially supports only NVM-based Node.js installations on OS X and Linux

## Installing the Steroids CLI package

You'll want to use the `steroids` command globally, so you should install Steroids CLI with the `-g` option:

<pre class="terminal">
$ npm install steroids -g
</pre>

npm might give you a few alerts about some third party libraries. This doesn't affect Steroids. However, if npm fails to install a third party library and gives an error, it can be typically fixed just by running the `$ npm install steroids -g` command again.

If you're getting `ENOTEMPTY` errors while installing, the cause might be some old, incompatible packages that have been cached by npm. You can try `$ npm cache clean` to clean previously cached npm packages from your `~/node_modules` directory.

##Updating Steroids

<em><strong>NOTE:</strong> if you are updating Steroids after changing your Node.js version, you should use `$ npm install steroids -g` instead of `update`. If you run into any issues, running `$ npm uninstall steroids -g` and re-installing should fix most problems. Let us know on the [forums][forums] if you are still having problems.</em>

The Steroids CLI checks for updates automatically when it is run, and will let you know when a new version is out. Remember to use the global `-g` option also when updating:

<pre class="terminal">
$ npm update steroids -g
</pre>

[xcode]: https://developer.apple.com/xcode/
[git]: http://git-scm.com/
[nodejs]: http://nodejs.org/
[npm]: https://npmjs.org/
[nvm]: https://github.com/creationix/nvm
[python]: http://www.python.org/
[forums]: http://forums.appgyver.com
