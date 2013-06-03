---
layout: post
title:  "Installing the Steroids NPM package"
date:   2013-05-27 13:51:34
categories: steroids_npm
platforms: iOS, Android
---

##Installing the Required Dependencies

**Please notice:** Steroids NPM currently only works with OS X and Linux.

First, you need to make sure that you have these set up:

* [Xcode][xcode] with Command Line Tools (only required on OS X)
* [Git][git] (required by external Node.js libraries)

Most importantly, you need to have [Node.js][nodejs] version 0.8.x and [NPM package management][npm] installed. 

The easiest way to install Node.js is with [Node Version Manager (NVM)][nvm]. Install NVM with:

<pre class="terminal">
$ curl https://raw.github.com/creationix/nvm/master/install.sh | sh
</pre>

Note that by default NVM adds initialization lines to `.bash_profile`, so you need to make sure these lines are loaded (by restarting Terminal).

To install Node.js 0.8.x with NVM and set it as the default Node.js version to use:

<pre class="terminal">
$ nvm install 0.8
$ nvm use 0.8
$ nvm alias default 0.8
</pre>

*Newer versions of Node.js have stability issues and limited support for certain third-party libraries. Thus, Steroids currently runs using Node.js version 0.8.x only. NVM allows you to install and use multiple versions of Node.js, so just make sure you have the correct version loaded when using Steroids.*

Alternatively, if you don't want to use NVM, you can install Node.js and NPM package management from [nodejs.org][nodejs].

##Installing the Steroids NPM package

You'll want to use the `steroids` command globally, so you should install Steroids NPM with the `-g` option:

<pre class="terminal">
$ npm install steroids -g
</pre>

NPM might give you a few alerts about some 3rd party libraries. This doesn't affect Steroids. However, if NPM fails to install a 3rd party library and gives an error, it can be typically fixed just by running the `$ npm install steroids -g` command again.

##Updating Steroids

The Steroids NPM checks for updates automatically when it is run, and will let you know when a new version is out. Remember to use the global `-g` option also when updating:

<pre class="terminal">
$ npm update steroids -g
</pre>

[xcode]: https://developer.apple.com/xcode/
[git]: http://git-scm.com/
[nodejs]: http://nodejs.org/
[npm]: https://npmjs.org/
[nvm]: https://github.com/creationix/nvm