---
layout: post
title:  "Installing the Steroids NPM package"
date:   2013-05-27 13:51:34
categories: steroids-npm
platforms: iOS Android
---

##Installing the Required Dependencies

**Please notice:** Steroids NPM currently only works with Mac OS X (with Xcode installed) and Linux.

First, you need to make sure that you have these set up:

Xcode</a> with Command Line Tools (OS X only, used to compile)</li>
  <li><a href="http://git-scm.com/" target="_blank">Git (required by external Node libraries)</a></li>
</ul>

<p>Most importantly you need to have Node.js and NPM package management installed.  The easiest way to install Node.js is Node Version Manager (NVM):</p>

<pre>$ curl https://raw.github.com/creationix/nvm/master/install.sh | sh</pre>

<p><b>Note</b> that by default NVM adds initialization lines to <code>.bash_profile</code>, so you need to make sure these lines are loaded (by restarting Terminal).</p>

To install Node.js 0.8.x with nvm and set it as default:

<pre>$ nvm install 0.8
$ nvm use 0.8
$ nvm alias default 0.8
</pre>

<div class="alert">
<p>Due to stability issues and limited support in third-party plugins, Steroids currently runs on Node.js 0.8.x. If you are using a newer version of Node.js, you need to downgrade.</p>
</div>

<p>Alternatively if you don't want to use nvm, you can install Node.js and NPM package management from <a href="http://nodejs.org/" target="_blank">http://nodejs.org/</a></p>

<h1>Installing the Steroids NPM package.</h1>

<p>Install Steroids globally with the -g option:</p>

<pre>$ npm install steroids -g</pre>

<div class="alert">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <p><strong>Notice:</strong> NPM might give you a few alerts about some 3rd party libraries. This doesn't affect Steroids. However, if NPM fails to install a 3rd party library and gives an error, it can be typically fixed just by runing the "npm install steroids -g" command again.</p>
</div>

<p><b>Now you're set to start developing some awesome apps!</b></p>

<p>You can mark this lesson completed, and continue to the next lesson.</p>

https://developer.apple.com/xcode/