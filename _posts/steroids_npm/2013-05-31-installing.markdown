---
layout: post
title:  "Installing the Steroids npm package"
date:   2013-05-27 13:51:34
categories: steroids_npm
platforms: iOS, Android
---

##Installing the Required Dependencies

**Please notice:** Steroids npm currently only works with OS X and Linux.

First, you need to make sure that you have these set up:

* [Xcode][xcode] with Command Line Tools (only required on OS X)
* [Git][git] (required by external Node.js libraries)
* [Python v2.7 or newer][python] (required by external Node.js libraries)

Most importantly, you need to have [Node.js][nodejs] version 0.8.x and [npm package management][npm] installed.

The easiest way to install Node.js is with [Node Version Manager (NVM)][nvm]. Install NVM with:

<pre class="terminal">
$ curl https://raw.github.com/creationix/nvm/master/install.sh | sh
</pre>

Note that by default NVM adds initialization lines to `.bash_profile`, so you need to make sure these lines are loaded (by restarting Terminal).

## Manual install on Linux

The `sh` command might not work with certain Linux distributions. You need to install NVM manually:

### Install dependencies
<pre class="terminal">
$ sudo apt-get install build-essential libssl-dev curl git-core
</pre>

### Download NVM
<pre class="terminal">
$ git clone git://github.com/creationix/nvm.git ~/.nvm
</pre>

### Source NVM from your bash shell

Add the following line to the end of your `~/.bashrc` file:

```
source ~/.nvm/nvm.sh
```
### Open a new bash session
Type `$ bash` in the Terminal to open a new Bash session. The `$ nvm` command should now work.

## Installing the correct version of Node.js

To install Node.js 0.8.x with NVM and set it as the default Node.js version to use:

<pre class="terminal">
$ nvm install 0.8
$ nvm use 0.8
$ nvm alias default 0.8
</pre>

*Newer versions of Node.js have stability issues and limited support for certain third-party libraries. Thus, Steroids currently runs using Node.js version 0.8.x only. NVM allows you to install and use multiple versions of Node.js, so just make sure you have the correct version loaded when using Steroids.*

Alternatively, if you don't want to use NVM, you can install Node.js and npm package management from [nodejs.org][nodejs].

##Installing the Steroids npm package

You'll want to use the `steroids` command globally, so you should install Steroids npm with the `-g` option:

<pre class="terminal">
$ npm install steroids -g
</pre>

npm might give you a few alerts about some third party libraries. This doesn't affect Steroids. However, if npm fails to install a 3rd party library and gives an error, it can be typically fixed just by running the `$ npm install steroids -g` command again.

##Updating Steroids

The Steroids npm checks for updates automatically when it is run, and will let you know when a new version is out. Remember to use the global `-g` option also when updating:

<pre class="terminal">
$ npm update steroids -g
</pre>

[xcode]: https://developer.apple.com/xcode/
[git]: http://git-scm.com/
[nodejs]: http://nodejs.org/
[npm]: https://npmjs.org/
[nvm]: https://github.com/creationix/nvm
[python]: http://www.python.org/
